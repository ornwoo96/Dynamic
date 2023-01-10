//
//  DetailViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import AVFoundation
import Combine

import Photos

class DetailViewController: UIViewController, HasCoordinatable {
    weak var coordinator: Coordinator?
    private var castedCoordinator: DetailCoordinator? { coordinator as? DetailCoordinator }
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: DetailViewModel
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loadingView = PageLoadingView()
    
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
        setupLongGestureRecognizerOnCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = nil
        setupImageData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.image = nil
    }
    
    private func setupUI() {
        setupImageView()
        setupLoadingView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: yValueRatio(90)),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingView.backgroundColor = .clear
    }
    
    private func bind() {
        bindImageData()
        bindEvent()
    }
    
    private func bindImageData() {
        viewModel.imageDataSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.imageView.image = UIImage.gifImageWithData($0)
            })
            .store(in: &cancellables)
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let strongSelf = self else { return }
                switch $0 {
                case .none: break
                case .hideLoading:
                    strongSelf.hideLoading()
                case .showLoading:
                    strongSelf.showLoading()
                }
            })
            .store(in: &cancellables)
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        loadingView.bounceAnimation()
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
    }
    
    private func setupImageData() {
        guard let url = castedCoordinator?.detailData?.url else { return }
        viewModel.action(.viewDidLoad(url))
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(LongPressCell(_:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        view.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func LongPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            saveImage()
        }
    }
    
    private func saveImage() {
        let imageData = viewModel.imageDataSubject.value
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: imageData, options: nil)
        }) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                print("GIF has saved")
            }
        }
    }
}
