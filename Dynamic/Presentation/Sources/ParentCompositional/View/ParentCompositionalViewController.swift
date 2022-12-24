//
//  CompositionalViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import Combine

final class ParentCompositionalViewController: UIViewController, HasCoordinatable {
    private var viewModel: ParentCompositionalViewModelProtocol
    var coordinator: Coordinator?
    private var castedCoordinator: ParentCompositionalCoordinator? { coordinator as? ParentCompositionalCoordinator }
    private var customNavigationBar = CustomNavigationBar()
    private var customNavigationBarTopConstraint: NSLayoutConstraint?
    private var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal)
    private var categoryView = CategoryView()
    
    init(viewModel: ParentCompositionalViewModelProtocol,
         viewControllers: [ChildCompositionalViewController]) {
        self.viewModel = viewModel
        self.viewModel.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        customNavigationBar.backgroundColor = .blue
        customNavigationBar.delegate = self
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
        view.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: yValueRatio(45))
        ])
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if let firstViewController = viewModel.viewControllers.first {
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .forward,
                                                  animated: false)
        }
        
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: yValueRatio(10)),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(categoryView)
    }
}

extension ParentCompositionalViewController: CustomNavigationBarDelegate {
    func favoritesButtonTapped() {
        castedCoordinator?.pushPickListView()
    }
}

extension ParentCompositionalViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 1 {
            animateHideBar()
        } else {
            animateShowBar()
        }
    }
}

extension ParentCompositionalViewController {
    
    private func animateHideBar() {
        DispatchQueue.main.async {
            if self.viewModel.isCustomNavigationBarAnimationFirst == false {
                self.customNavigationBarTopConstraint?.constant = -100
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                
                self.viewModel.isCustomNavigationBarAnimationFirst = true
            }
        }
    }
    
    private func animateShowBar() {
        DispatchQueue.main.async {
            if self.viewModel.isCustomNavigationBarAnimationFirst {
                self.customNavigationBarTopConstraint?.constant = 0


                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
                self.viewModel.isCustomNavigationBarAnimationFirst = false
            }
        }
    }
}

extension ParentCompositionalViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.viewControllers.firstIndex(of: viewController as! ChildCompositionalViewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return viewModel.viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.viewControllers.firstIndex(of: viewController as! ChildCompositionalViewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewModel.viewControllers.count {
            return nil
        }
        return viewModel.viewControllers[nextIndex]
    }
}
