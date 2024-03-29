//
//  CompositionalViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import Combine

internal final class ParentCompositionalViewController: UIViewController, HasCoordinatable {
    private var viewModel: ParentCompositionalViewModelProtocol
    weak var coordinator: Coordinator?
    private var cancellable: Set<AnyCancellable> = .init()
    private var castedCoordinator: ParentCompositionalCoordinator? { coordinator as? ParentCompositionalCoordinator }
    private var customNavigationBar = CustomNavigationBar(.main)
    private var customNavigationBarTopConstraint: NSLayoutConstraint?
    private var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal)
    private var categoryView = CategoryView()
    private var categoryViewTopConstraint: NSLayoutConstraint?
    private var pageViewTopConstraint: NSLayoutConstraint?
    
    init(viewModel: ParentCompositionalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewDidLoad)
    }
    
    private func setupUI() {
        setupCustomNavigationBar()
        setupCategoryView()
        setupViewController()
        setupPageViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.mainNavigationBar.delegate = self
        view.addSubview(customNavigationBar)
        customNavigationBarTopConstraint = customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90)),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        customNavigationBarTopConstraint?.isActive = true
    }
    
    private func setupCategoryView() {
        categoryView.delegate = self
        view.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryViewTopConstraint = categoryView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor)
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: yValueRatio(45))
        ])
        categoryViewTopConstraint?.isActive = true
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if let firstViewController = castedCoordinator?.childViewControllers.first {
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .forward,
                                                  animated: false)
        }
            
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: yValueRatio(5))
        ])
        view.bringSubviewToFront(categoryView)
    }
    
    private func bind() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let strongSelf = self else { return }
                switch $0 {
                case .none: break
                case .setViewControllersToForward(let viewController):
                    strongSelf.setViewControllerToForward(viewController)
                case .setViewControllersToReverse(let viewController):
                    strongSelf.setViewControllersToReverse(viewController)
                case .setupPickListButtonCount(let count):
                    strongSelf.setupPickListButtonCount(count)
                case .animateHideNavigationBar:
                    strongSelf.animateHideNavigationBar()
                case .animateShowNavigationBar:
                    strongSelf.animateShowNavigationBar()
                }
            }
            .store(in: &cancellable)
    }
}

extension ParentCompositionalViewController {
    internal func animateNavigationBar(state: ParentCompositionalViewModel.NavigationBarState) {
        viewModel.action(.navigationBarState(state: state))
    }
    
    private func animateHideNavigationBar() {
        customNavigationBarTopConstraint?.constant = -yValueRatio(100)
        categoryViewTopConstraint?.constant = yValueRatio(70)
        UIView.animate(withDuration: 0.2) {
            self.categoryView.setupBackGroundViewWhenHideBar()
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowNavigationBar() {
        customNavigationBarTopConstraint?.constant = 0
        categoryViewTopConstraint?.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.categoryView.setupBackGroundViewWhenShowBar()
            self.view.layoutIfNeeded()
        }
    }
    
    internal func setupFavoritesCountData(_ count: Int) {
        viewModel.action(.receiveFavoritesCountData(count))
    }
    
    private func setupPickListButtonCount(_ count: Int) {
        customNavigationBar.mainNavigationBar.checkNumber(count)
    }
}

extension ParentCompositionalViewController: CategoryViewProtocol {
    func buttonDidTap(_ tag: Int) {
        if let childViewController = castedCoordinator?.childViewControllers[tag] {
            viewModel.action(.categoryButtonDidTap(tag, childViewController))
        }
    }
    
    private func setViewControllerToForward(_ viewController: ChildCompositionalViewController) {
        pageViewController.setViewControllers([viewController],
                                              direction: .forward,
                                              animated: true)
    }
    
    private func setViewControllersToReverse(_ viewController: ChildCompositionalViewController) {
        pageViewController.setViewControllers([viewController],
                                              direction: .reverse,
                                              animated: true)
    }
}

extension ParentCompositionalViewController: CustomNavigationBarDelegate {
    func favoritesButtonTapped() {
        castedCoordinator?.pushPickListView()
    }
}

extension ParentCompositionalViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChildCompositionalViewController,
              let index = castedCoordinator?.childViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        
        return castedCoordinator?.childViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChildCompositionalViewController,
              let index = castedCoordinator?.childViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == castedCoordinator?.childViewControllers.count {
            return nil
        }
        
        return castedCoordinator?.childViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first as? ChildCompositionalViewController,
              let index = castedCoordinator?.childViewControllers.firstIndex(of: viewController) else { return }
        categoryView.branchButtonTag(index)
        viewModel.changeIndex(index)
    }
}
