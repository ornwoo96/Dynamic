//
//  PickListViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import Combine

class PickListViewController: UIViewController, HasCoordinatable {
    let viewModel: PickListViewModel
    weak var coordinator: Coordinator?
    private var castedCoordinator: PickListCoordinator? { coordinator as? PickListCoordinator }
    private var cancellable = Set<AnyCancellable>()
    
    private var customNavigationBar = CustomNavigationBar(.favorites)

    private lazy var pickListCollectionView: UICollectionView = {
        let layout = DynamicCustomFlowLayout()
        layout.cellPadding = self.xValueRatio(2.5)
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PickListCollectionViewCell.self,
                                forCellWithReuseIdentifier: PickListCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: xValueRatio(5),
                                                   left: xValueRatio(5),
                                                   bottom: xValueRatio(10),
                                                   right: xValueRatio(5))
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    init(viewModel: PickListViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.action(.viewDidDisappear)
    }
    
    private func setupUI() {
        setupCustomNavigationBar()
        setupLongGestureRecognizerOnCollection()
        setupCollectionView()
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.favoritesNavigationBar.delegate = self
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90)),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupCollectionView() {
        view.addSubview(pickListCollectionView)
        pickListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickListCollectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            pickListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(customNavigationBar)
    }
    
    private func bind() {
        bindEvent()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in
                switch $0 {
                case .none:
                    break
                case .invalidateLayout:
                    self?.pickListCollectionView.reloadData()
                case .deleteItem(let indexPath):
                    self?.setupCellWhenCellLongPressed(indexPath)
                }
            })
            .store(in: &cancellable)
    }
    
}

extension PickListViewController: BackButtonProtocol {
    func backButtonDidTap() {
        castedCoordinator?.popViewController()
    }
}

extension PickListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickListCollectionViewCell.identifier, for: indexPath) as? PickListCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = nil
        cell.configure(viewModel.contents[indexPath.item].url)
        return cell
    }
}

extension PickListViewController: DynamicCollectionViewHeightLayoutDelegate {
    func collectionViewImageHeight(_ collectionView: UICollectionView,
                                   _ heightForImageAtIndexPath: IndexPath) -> CGFloat {
        let string = viewModel.contents[heightForImageAtIndexPath.item].height
        let height: CGFloat = CGFloat(Int(string) ?? 0)
        
        return height
    }
    
    func collectionViewImageWidth(_ collectionView: UICollectionView,
                                  _ widthForImageAtIndexPath: IndexPath) -> CGFloat {
        
        let string = viewModel.contents[widthForImageAtIndexPath.item].width
        let width: CGFloat = CGFloat(Int(string) ?? 0)
        
        return width
    }
}

extension PickListViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(LongPressCell(_:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        pickListCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func LongPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            viewModel.action(.didSelectedItemAtLongPressed(indexPath: findLongPressCellIndexPath(gestureRecognizer)))
        }
    }
    
    private func findLongPressCellIndexPath(_ gestureRecognizer: UILongPressGestureRecognizer) -> IndexPath {
        let location = gestureRecognizer.location(in: pickListCollectionView)
        guard let indexPath = pickListCollectionView.indexPathForItem(at: location) else { return IndexPath() }
        return indexPath
    }
    
    private func setupCellWhenCellLongPressed(_ indexPath: IndexPath) {
        viewModel.contents.remove(at: indexPath.item)
        pickListCollectionView.deleteItems(at: [indexPath])
    }
}
