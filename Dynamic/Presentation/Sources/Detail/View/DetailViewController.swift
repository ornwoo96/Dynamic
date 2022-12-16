//
//  DetailViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

final class DetailViewController: UIViewController, HasCoordinatable {
    weak var coordinator: Coordinator?
    private var castedCoordinator: DetailCoordinator? { coordinator as? DetailCoordinator }
    let viewModel: DetailViewModel
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        guard let imageData = castedCoordinator?.detailData?.detailImage else { return UIImageView() }
        imageView.image = UIImage(data: imageData)
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
    }
    
    private func setupUI() {
        setupImageView()
    }
    
    private func setupImageView() {
        let castedWidth: CGFloat = CGFloat(Int(castedCoordinator?.detailData?.width ?? "0") ?? 0)
        let castedHeight: CGFloat = CGFloat(Int(castedCoordinator?.detailData?.height ?? "0") ?? 0)
        
        let resizeWidth: CGFloat = CGFloat.ImageResizeHeight(castedWidth,
                                                             castedHeight,
                                                             calculateXMax(),
                                                             calculateYMax())
        let resizeHeight: CGFloat = CGFloat.ImageResizeHeight(castedWidth,
                                                              castedHeight,
                                                              calculateXMax(),
                                                              calculateYMax())
        
        view.addSubview(detailImageView)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailImageView.widthAnchor.constraint(equalToConstant: resizeWidth),
            detailImageView.heightAnchor.constraint(equalToConstant: resizeHeight)
        ])
    }
}
