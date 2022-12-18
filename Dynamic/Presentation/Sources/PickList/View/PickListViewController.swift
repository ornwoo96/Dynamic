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
    
    
    
    init(viewModel: PickListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
}
