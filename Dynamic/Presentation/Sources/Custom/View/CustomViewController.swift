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
    private lazy var collectionView: UICollectionView = {
        let layout = DynamicCustomFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: xValueRatio(35), left: xValueRatio(5), bottom: xValueRatio(10), right: xValueRatio(5))
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
    }
    
    private func setupViewController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        bindPreviewData()
        bindEvent()
    }
    
    private func bindPreviewData() {
        viewModel.previewImageDataSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            self.collectionView.reloadData()
        }
        .store(in: &cancellable)
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                switch $0 {
                case .showDetailView(let data):
                    self?.showDetailView(data)
                case .showLoading:
                    print("ShowLoading")
                case .hideLoading:
                    print("hideLoading")
                case .none: break
                }
            })
            .store(in: &cancellable)
    }
    
    private func showDetailView(_ data: DetailModel) {
        castedCoordinator?.presentDetailView(data)
    }
}

extension CustomViewController: DynamicCollectionViewHeightLayoutDelegate {
    func collectionViewImageHeight(_ collectionView: UICollectionView,
                                   _ heightForImageAtIndexPath: IndexPath) -> CGFloat {
        let string = viewModel.previewImageDataSubject.value.contents.previewImages[heightForImageAtIndexPath.item].height
        let height: CGFloat = CGFloat(Int(string) ?? 0)
        
        return height
    }
    
    func collectionViewImageWidth(_ collectionView: UICollectionView,
                                  _ widthForImageAtIndexPath: IndexPath) -> CGFloat {
        let string = viewModel.previewImageDataSubject.value.contents.previewImages[widthForImageAtIndexPath.item].width
        let width: CGFloat = CGFloat(Int(string) ?? 0)
        
        return width
    }
}

extension CustomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.previewImageDataSubject.value.contents.originalImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
        cell.configure(self.viewModel, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        //MARK: 아직
        viewModel.action(.didSelectItemAt(indexPath: indexPath))
    }
}

extension CustomViewController: CustomNavigationBarDelegate {
    func favoritesButtonTapped() {
        castedCoordinator?.pushPickListView()
    }
}
