//
//  CompositionalViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import Combine

final class CompositionalViewController: UIViewController, HasCoordinatable {
    private let viewModel: CompositionalViewModelProtocol
    var coordinator: Coordinator?
    private var castedCoordinator: CompositionalCoordinator? { coordinator as? CompositionalCoordinator }
    private var layoutFactory = CompositionalLayoutFactory()
    private var cancellable: Set<AnyCancellable> = .init()
    private lazy var compositionalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
    private var dataSource: UICollectionViewDiffableDataSource<CompositionalViewModel.Section, BaseCellItem>?
    private var customNavigationBar = CustomNavigationBar()
    private var customNavigationBarTopConstraint: NSLayoutConstraint?

    init(viewModel: CompositionalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        setupLongGestureRecognizerOnCollection()
        setupUI()
        bind()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        setupViewController()
        setupCollectionView()
        setupCustomNavigationBar()
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
    }
    
    private func setupCollectionView() {
        compositionalCollectionView.backgroundColor = .black
        compositionalCollectionView.delegate = self
        compositionalCollectionView.register(CompositionalCollectionViewCell.self,
                                             forCellWithReuseIdentifier: CompositionalCollectionViewCell.identifier)
        view.addSubview(compositionalCollectionView)
        compositionalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compositionalCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            compositionalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compositionalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            compositionalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.backgroundColor = .blue
        customNavigationBar.delegate = self
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90)),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func bind() {
        bindEvent()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .none:
                    break
                case .reloadData(sections: let sections):
                    self?.reloadData(sections)
                case .showDetailView(let data):
                    self?.showDetailView(data)
                case .showLoading:
                    break
                case .hideLoading:
                    break
                case .invalidateLayout:
                    self?.invalidateLayout()
                case .showHeartView(indexPath: let indexPath):
                    self?.setupCellWhenCellLongPressed(indexPath)
                }
            }
            .store(in: &cancellable)
    }
    
    private func reloadData(_ sections: [CompositionalViewModel.Section]) {
        var snapShot = NSDiffableDataSourceSnapshot<CompositionalViewModel.Section, BaseCellItem>()

        sections.forEach {
            snapShot.appendSections([$0])
            snapShot.appendItems($0.items)
        }
        
        dataSource?.apply(snapShot)
    }
    
    private func setDataSource() {
        dataSource = .init(collectionView: compositionalCollectionView) { [weak self] in
            guard let strongSelf = self else {
                return $0.dequeueReusableCell(withReuseIdentifier: "cell", for: $1)
            }
            
            if let cell = $0.dequeueReusableCell(withReuseIdentifier: CompositionalCollectionViewCell.identifier,
                                                 for: $1) as? CompositionalCollectionViewCell,
               let item = $2 as? CompositionalCellItem {
                
                cell.configure(item)
                return cell
            }
            

            return $0.dequeueReusableCell(withReuseIdentifier: "cell", for: $1)
        }
    }
    
    private func invalidateLayout() {
        if let visibleIndexPaths = compositionalCollectionView.indexPathsForVisibleItems.min(by: { $0.item < $1.item }),
              visibleIndexPaths.isEmpty == false {
            
            compositionalCollectionView.reloadData()
            
            
            compositionalCollectionView.scrollToItem(at: visibleIndexPaths, at: .top, animated: false)
        } else{
            compositionalCollectionView.reloadData()
        }
    }
    
    private func showDetailView(_ data: DetailModel) {
        castedCoordinator?.presentDetailView(self, data)
    }
    
}

// MARK: Tab 변경시 Repository에 있는 cache 값도 바꿔주는 코드 하나 추가
// MARK: navigation animation

extension CompositionalViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            
            guard let sectionItem = self?.viewModel.getSectionItem(sectionIndex) else {
                return self?.layoutFactory.getEmptySection()
            }
            
            let numberOfItem = sectionItem.items.count

            let section = self?.layoutFactory.getDynamicLayoutSection(
                columnCount: 2,
                itemPadding: 10,
                contentWidth: environment.container.effectiveContentSize.width,
                numberOfItems: numberOfItem,
                sectionItem: sectionItem
            )

            return section
        }
    }
}

extension CompositionalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.didSelectItemAt(indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.action(.willDisplay(indexPath))
    }
}

extension CompositionalViewController: CustomNavigationBarDelegate {
    func favoritesButtonTapped() {
        castedCoordinator?.pushPickListView()
    }
}

extension CompositionalViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(LongPressCell(_:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        compositionalCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func LongPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            viewModel.action(.didSelectedItemAtLongPressed(indexPath: findLongPressCellIndexPath(gestureRecognizer)))
        }
    }

    private func findLongPressCellIndexPath(_ gestureRecognizer: UILongPressGestureRecognizer) -> IndexPath {
        let location = gestureRecognizer.location(in: compositionalCollectionView)
        guard let indexPath = compositionalCollectionView.indexPathForItem(at: location) else { return IndexPath() }
        
        return indexPath
    }

    private func setupCellWhenCellLongPressed(_ indexPath: IndexPath) {
        guard let cell = compositionalCollectionView.cellForItem(at: indexPath) as? CompositionalCollectionViewCell else { return }
        
        viewModel.checkFavoriteButtonTapped(cell.checkHeartViewIsHidden(), indexPath.item)
    }
}

extension CompositionalViewController {
    // MARK: NavigationBar Animation
    private enum Action {
        case hideBar
        case showBar
    }
    
    private func animateHideBar() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowBar() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
