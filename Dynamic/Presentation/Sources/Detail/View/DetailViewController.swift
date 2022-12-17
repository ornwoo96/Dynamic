//
//  DetailViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import AVFoundation
import Combine

class DetailViewController: UIViewController, HasCoordinatable {
    weak var coordinator: Coordinator?
    private var castedCoordinator: DetailCoordinator? { coordinator as? DetailCoordinator }
    private var cancellables: Set<AnyCancellable> = .init()
    let viewModel: DetailViewModel
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    init(viewModel: DetailViewModel) {
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
        setupImageData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.image = nil
    }
    
    private func setupUI() {
        setupImageView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind() {
        bindImageData()
    }
    
    private func bindImageData() {
        viewModel.imageDataSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.imageView.image = UIImage.gifImageWithData($0)
            })
            .store(in: &cancellables)
    }
    
    
    private func setupImageData() {
        guard let url = castedCoordinator?.detailData?.url else { return }
        
        viewModel.action(.viewDidLoad(url))
    }
}
