//
//  CustomViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

import Combine

class CustomViewController: UIViewController, HasCoordinatable {
    private var viewModel: CustomViewModel
    weak var coordinator: Coordinator?
    private var castedCoordinator: CustomCoordinator? { coordinator as? CustomCoordinator }
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var customCollectionView: UICollectionView = {
        let layout = DynamicCustomFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: xValueRatio(35),
                                                   left: xValueRatio(5),
                                                   bottom: xValueRatio(10),
                                                   right: xValueRatio(5))
        collectionView.isPrefetchingEnabled = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private var customNavigationBar = CustomNavigationBar()
    
    init(viewModel: CustomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        bind()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        setupCollectionView()
        setupViewController()
        setupCustomNavigationBar()
        setupLongGestureRecognizerOnCollection()
    }
    
    private func setupViewController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCollectionView() {
        view.addSubview(customCollectionView)
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.delegate = self
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(100)),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(30))
        ])
    }
    
    private func bind() {
        bindEvent()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                switch $0 {
                case .invalidateLayout:
                    self?.invalidateLayout()
                case .showDetailView(let data):
                    self?.showDetailView(data)
                case .showLoading:
                    print("ShowLoading")
                case .hideLoading:
                    print("hideLoading")
                case .showHeartView(let indexPath):
                    self?.setupCellWhenCellLongPressed(indexPath)
                case .none: break
                }
            })
            .store(in: &cancellable)
    }
    
    private func invalidateLayout() {
        if let visibleIndexPaths = customCollectionView.indexPathsForVisibleItems.min(by: { $0.item < $1.item }),
           visibleIndexPaths.isEmpty == false {
            viewModel.event.send(.showLoading)
            
        } else{
            customCollectionView.reloadData()
        }
    }
    
    private func showDetailView(_ data: DetailModel) {
        castedCoordinator?.presentDetailView(self, data)
    }
}

extension CustomViewController: DynamicCollectionViewHeightLayoutDelegate {
    func collectionViewImageHeight(_ collectionView: UICollectionView,
                                   _ heightForImageAtIndexPath: IndexPath) -> CGFloat {
        
        let string = viewModel.contents.previewImages[heightForImageAtIndexPath.item].height
        let height: CGFloat = CGFloat(Int(string) ?? 0)
        
        return height
    }
    
    func collectionViewImageWidth(_ collectionView: UICollectionView,
                                  _ widthForImageAtIndexPath: IndexPath) -> CGFloat {
        
        let string = viewModel.contents.previewImages[widthForImageAtIndexPath.item].width
        let width: CGFloat = CGFloat(Int(string) ?? 0)
        
        return width
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if viewModel.event.value == .showLoading {
//            customCollectionView.reloadData()
//        }
//        viewModel.event.send(.hideLoading)
    }
}

extension CustomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.contents.originalImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
                                                            for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
        cell.configure(self.viewModel, indexPath)
        
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
}

extension CustomViewController: CustomNavigationBarDelegate {
    func favoritesButtonTapped() {
        castedCoordinator?.pushPickListView()
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
}
