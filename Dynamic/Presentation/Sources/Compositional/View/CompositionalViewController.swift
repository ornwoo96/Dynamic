//
//  CompositionalViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

final class CompositionalViewController: UIViewController {
    private let viewModel: CompositionalViewModel
    var coordinator: CompositionalCoordinator?
    
    init(viewModel: CompositionalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        viewModel.viewDidLoad()
    }
}
