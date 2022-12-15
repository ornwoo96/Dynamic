//
//  CustomViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

import Combine

final class CustomViewController: UIViewController {
    private var viewModel: CustomViewModel
    weak var coordinator: CustomCoordinator?
    private var cancellable = Set<AnyCancellable>()
    private lazy var collectionView: UICollectionView = {
        let layout = DynamicCustomFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        return collectionView
    }()
    
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
        bindViewModel()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupUI() {
        setupCollectionView()
        setupViewController()
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
    
    private func bindViewModel() {
        viewModel.previewImageDataSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            self.collectionView.reloadData()
        }
        .store(in: &cancellable)
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
}
