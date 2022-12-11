//
//  MainViewController.swift
//  Presentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

final class MainViewController: UIViewController {
    
    
    let mainViewModel: MainViewModelProtocol
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        mainViewModel.viewDidLoad()
        view.backgroundColor = .white
    }
}
