//
//  DetailViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import Combine

import Photos
import AVFoundation
import GIFO

internal class DetailViewController: UIViewController, HasCoordinatable {
    weak var coordinator: Coordinator?
    private var castedCoordinator: DetailCoordinator? { coordinator as? DetailCoordinator }
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: DetailViewModelProtocol
    
    private lazy var imageView: GIFOImageView = {
        let imageView = GIFOImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let loadingView = PageLoadingView()
    private let saveGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private var saveImageFrontViewHeightConstraint: NSLayoutConstraint?
    private var saveImageFrontViewCenterYConstraint: NSLayoutConstraint?
    private var saveImageFrontViewWidthConstraint: NSLayoutConstraint?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var imageViewWidthConstraint: NSLayoutConstraint?
    
    private lazy var saveImageFrontView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gifDownloadColor
        return view
    }()
    
    private lazy var saveImageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: yValueRatio(25), weight: .heavy)
        label.text = "GIF Save Complete"
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    init(viewModel: DetailViewModelProtocol) {
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
        viewModel.action(.viewWillAppear)
        imageView.image = nil
        setupDetailSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupResizeImageView()
        setupImageData()
        setupResizeImageFrontView()
        saveImageFrontView.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.clearWithDisplayLink()
        castedCoordinator?.detailData = nil
        saveImageFrontView.isHidden = true
        saveImageLabel.alpha = 0
    }
    
    private func setupDetailSize() {
        guard let height = castedCoordinator?.detailData?.height,
              let width = castedCoordinator?.detailData?.width else { return }
        
        viewModel.setupDetailHeightData(height)
        viewModel.setupDetailWidthData(width)
    }
    
    private func setupUI() {
        setupLoadingView()
        setupImageView()
        setupGifImageFrontView()
        setupSaveImageLabel()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewHeightConstraint = imageView.heightAnchor.constraint(
            equalToConstant: CGFloat.resizeHeight(height: viewModel.retrieveDetailHeightData(),
                                                  width: viewModel.retrieveDetailWidthData()))
        imageViewWidthConstraint = imageView.widthAnchor.constraint(
            equalToConstant: CGFloat.resizeWidth(height: viewModel.retrieveDetailHeightData(),
                                                 width: viewModel.retrieveDetailWidthData()))
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        imageViewWidthConstraint?.isActive = true
        imageViewHeightConstraint?.isActive = true
    }
    
    private func setupResizeImageView() {
        imageViewHeightConstraint?.constant = CGFloat.resizeHeight(
            height: viewModel.retrieveDetailHeightData(),
            width: viewModel.retrieveDetailWidthData()
        )
        imageViewWidthConstraint?.constant = CGFloat.resizeWidth(
            height: viewModel.retrieveDetailHeightData(),
            width: viewModel.retrieveDetailWidthData()
        )
        
        self.view.layoutIfNeeded()
    }
    
    private func setupResizeImageFrontView() {
        saveImageFrontViewWidthConstraint?.constant = CGFloat.resizeWidth(
            height: viewModel.retrieveDetailHeightData(),
            width: viewModel.retrieveDetailWidthData()
        )
        saveImageFrontViewCenterYConstraint?.constant = CGFloat.resizeHeight(
            height: viewModel.retrieveDetailHeightData(),
            width:viewModel.retrieveDetailWidthData()
        )/2
        saveImageFrontViewHeightConstraint?.constant = 0
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
    
    private func setupGifImageFrontView() {
        imageView.addSubview(saveImageFrontView)
        saveImageFrontView.translatesAutoresizingMaskIntoConstraints = false
        saveImageFrontViewHeightConstraint = saveImageFrontView.heightAnchor.constraint(equalToConstant: 0)
        saveImageFrontView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveImageFrontViewCenterYConstraint = saveImageFrontView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor, constant: -(CGFloat.resizeHeight(height: viewModel.retrieveDetailHeightData(),
                                                                          width: viewModel.retrieveDetailWidthData())/2))
        saveImageFrontViewWidthConstraint = saveImageFrontView.widthAnchor.constraint(
            equalToConstant: CGFloat.resizeWidth(height: viewModel.retrieveDetailHeightData(),
                                                 width: viewModel.retrieveDetailWidthData())
        )
        saveImageFrontViewHeightConstraint?.isActive = true
        saveImageFrontViewCenterYConstraint?.isActive = true
        saveImageFrontViewWidthConstraint?.isActive = true
    }
    
    private func setupSaveImageLabel() {
        imageView.addSubview(saveImageLabel)
        saveImageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveImageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bind() {
        bindEvent()
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
        imageView.setupGIFImageWithDisplayLink(url: url,
                                               cacheKey: url,
                                               isCache: false) {
            self.viewModel.event.send(.hideLoading)
        }
    }
    
    private func dismissViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.castedCoordinator?.viewDismiss(self)
        }
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
            if viewModel.event.value == .hideLoading {
                animateSaveImage()
                saveImage()
            }
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
                self.dismissViewController()
            }
        }
    }
    
    private func animateSaveImage() {
        saveImageFrontViewCenterYConstraint?.constant = 0
        saveImageFrontViewHeightConstraint?.constant = CGFloat.resizeHeight(
            height: viewModel.retrieveDetailHeightData(),
            width: viewModel.retrieveDetailWidthData()
        )
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn) {
            self.imageView.layoutIfNeeded()
        }
        saveGenerator.impactOccurred()
        animateTextAlpha()
    }
    
    internal func animateTextAlpha() {
        UIView.animateKeyframes(withDuration: 1.0,
                                delay: 0.5) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 2.5/12,
                               animations: {
                self.saveImageLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 2.5/12,
                               relativeDuration: 2.5/12,
                               animations: {
                self.saveImageLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 5/12,
                               relativeDuration: 2/12,
                               animations: {
                self.saveImageLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 7/12,
                               relativeDuration: 2/12,
                               animations: {
                self.saveImageLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 9/12,
                               relativeDuration: 2/12,
                               animations: {
                self.saveImageLabel.alpha = 1.0
            })
        }
    }
}
