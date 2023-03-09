//
//  CustomViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import Combine

class CustomViewController: UIViewController, HasCoordinatable {
    private var viewModel: CustomViewModelProtocol
    var coordinator: Coordinator?
    private var castedCoordinator: CustomCoordinator? { coordinator as? CustomCoordinator }
    private var cancellable = Set<AnyCancellable>()
    private var loadingView = PageLoadingView()
    private let blackView = UIView()
    
    private lazy var customCollectionView: UICollectionView = {
        let layout = DynamicCustomFlowLayout()
        layout.cellPadding = 2.5
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.isPrefetchingEnabled = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    init(viewModel: CustomViewModelProtocol,
         category: CustomViewModel.Category) {
        self.viewModel = viewModel
        self.viewModel.setupCategory(category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewModel.action(.viewDidLoad)
        setupUI()
        bind()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewWillAppear)
    }
    
    private func setupUI() {
        setupBlackBackgroundView()
        setupCollectionView()
        setupLongGestureRecognizerOnCollection()
        setupLoadingView()
    }
    
    private func setupBlackBackgroundView() {
        blackView.backgroundColor = .black
        view.addSubview(blackView)
        blackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: view.topAnchor),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.heightAnchor.constraint(equalToConstant: yValueRatio(5))
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(customCollectionView)
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        customCollectionView.contentInset = UIEdgeInsets(top: .zero,
                                                         left: xValueRatio(2.5),
                                                         bottom: .zero,
                                                         right: xValueRatio(2.5))
        NSLayoutConstraint.activate([
            customCollectionView.topAnchor.constraint(equalTo: blackView.bottomAnchor, constant: -yValueRatio(2.5)),
            customCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(blackView)
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(loadingView)
    }
    
    private func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        customCollectionView.refreshControl = refresh
    }
    
    private func bind() {
        bindEvent()
        bindCurrentFavoritesCount()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let strongSelf = self else { return }
                switch $0 {
                case .none: break
                case .invalidateLayout:
                    strongSelf.invalidateLayout()
                case .showDetailView(let data):
                    strongSelf.showDetailView(data)
                case .showBottomLoading:
                    break
                case .hideBottomLoading:
                    break
                case .showHeartView(let indexPath):
                    strongSelf.setupCellWhenCellLongPressed(indexPath)
                case .showRetrievedCells(let indexPaths):
                    strongSelf.insertItemInCollectionView(indexPaths)
                case .animateHideBar:
                    strongSelf.animateHideBar()
                case .animateShowBar:
                    strongSelf.animateShowBar()
                case .endRefreshing:
                    strongSelf.endRefreshing()
                case .showPageLoading:
                    strongSelf.showPageLoading()
                case .hidePageLoading:
                    strongSelf.hidePageLoading()
                case .collectionViewReload:
                    strongSelf.collectionViewReloadData()
                }
            })
            .store(in: &cancellable)
    }
    
    private func bindCurrentFavoritesCount() {
        viewModel.favoritesCount
            .sink { [weak self] in
                self?.castedCoordinator?.passFavoritesCountDataToParent($0)
            }
            .store(in: &cancellable)
    }
    
    private func invalidateLayout() {
        if let visibleIndexPaths = customCollectionView.indexPathsForVisibleItems.min(by: { $0.item < $1.item }),
           visibleIndexPaths.isEmpty == false {
            viewModel.event.send(.showBottomLoading)
        } else{
            customCollectionView.reloadData()
        }
    }
    
    private func showDetailView(_ data: DetailModel) {
        castedCoordinator?.presentDetailView(self, data)
    }
    
    
    private func insertItemInCollectionView(_ indexPaths: [IndexPath]) {
        customCollectionView.insertItems(at:indexPaths)
    }
    
    private func showPageLoading() {
        loadingView.isHidden = false
        loadingView.bounceAnimation()
    }
    
    private func hidePageLoading() {
        loadingView.isHidden = true
    }
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        customCollectionView.refreshControl?.beginRefreshing()
        viewModel.action(.pullToRefresh)
    }
    
    private func endRefreshing() {
        customCollectionView.refreshControl?.endRefreshing()
    }
    
    private func animateHideBar() {
        castedCoordinator?.hideCustomNavigationBar()
    }
    
    private func animateShowBar() {
        castedCoordinator?.showCustomNavigationBar()
    }
    
    private func collectionViewReloadData() {
        customCollectionView.reloadData()
    }
    
    @objc private func scrollPanGestureAction(_ panGesture: UIPanGestureRecognizer) {
        viewModel.action(.scrollPanGestureAction(
            yValue: panGesture.velocity(in: customCollectionView).y
        ))
    }
}

extension CustomViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.action(.scrollViewDidScroll(scrollView.contentOffset.y))
    }
}

extension CustomViewController: DynamicCollectionViewHeightLayoutDelegate {
    func collectionViewImageHeight(_ collectionView: UICollectionView,
                                   _ heightForImageAtIndexPath: IndexPath) -> CGFloat {
        return viewModel.collectionViewImageHeight(heightForImageAtIndexPath)
    }
    
    func collectionViewImageWidth(_ collectionView: UICollectionView,
                                  _ widthForImageAtIndexPath: IndexPath) -> CGFloat {
        return viewModel.collectionViewImageWidth(widthForImageAtIndexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating()
    }
}

extension CustomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(viewModel.retrieveCustomCellItem(indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.didSelectItemAt(indexPath: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.action(.willDisplay(indexPath: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath) as? CustomCollectionViewCell else {
            return
        }
        cell.clear()
    }
}

extension CustomViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(LongPressCell(_:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        customCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func LongPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            viewModel.action(.didSelectedItemAtLongPressed(indexPath: findLongPressCellIndexPath(gestureRecognizer)))
        }
    }
    
    private func findLongPressCellIndexPath(_ gestureRecognizer: UILongPressGestureRecognizer) -> IndexPath {
        let location = gestureRecognizer.location(in: customCollectionView)
        guard let indexPath = customCollectionView.indexPathForItem(at: location) else { return IndexPath() }
        return indexPath
    }
    
    private func setupCellWhenCellLongPressed(_ indexPath: IndexPath) {
        guard let cell = customCollectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return }
        viewModel.checkFavoriteButtonTapped(cell.checkHeartViewIsHidden(), indexPath.item)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
