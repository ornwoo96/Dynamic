//
//  CompositionalViewController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import Combine

final class CompositionalViewController: UIViewController, HasCoordinatable {
    private let viewModel: CompositionalViewModelProtocol
    var coordinator: Coordinator?
    private lazy var layoutFactory = CompositionalLayoutFactory()
    private var cancellable: Set<AnyCancellable> = .init()

    private lazy var compositionalCollectionView: UICollectionView = {
        let layout = makeCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<CompositionalViewModel.Section, BaseCellItem>?
    
    init(viewModel: CompositionalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        setupUI()
        bind()
        setDataSource()
    }
    
    private func setupUI() {
        setupViewController()
        setupCollectionView()
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
    }
    
    private func setupCollectionView() {
        view.addSubview(compositionalCollectionView)
        compositionalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compositionalCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            compositionalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compositionalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            compositionalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind() {
        bindEvent()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .none:
                    break
                case .reloadData(sections: let sections):
                    self?.reloadData(sections)
                case .showDetailView(selectedIndex: let selectedIndex,
                                     contents: let contents):
                    break
                case .showLoading:
                    break
                case .hideLoading:
                    break
                }
            }
            .store(in: &cancellable)
    }
    
    private func reloadData(_ sections: [CompositionalViewModel.Section]) {
        var snapShot = NSDiffableDataSourceSnapshot<CompositionalViewModel.Section, BaseCellItem>()
        
        sections.forEach {
            snapShot.appendSections([$0])
            snapShot.appendItems($0.items)
        }
        
        dataSource?.apply(snapShot)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.compositionalCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CompositionalCollectionViewCell.identifier,
                for: indexPath
            ) as? CompositionalCollectionViewCell else {
                return UICollectionViewCell()
            }
            
//            cell.configure(self.viewModel as! CustomViewModelProtocol, )
            
            
            return cell
        })
    }
    
}

extension CompositionalViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let strongSelf = self else { return  }
            
            let sectionItem = strongSelf.viewModel.getSectionItem(sectionIndex: sectionIndex)
            
            let numberOfItem = strongSelf.compositionalCollectionView.numberOfItems(inSection: sectionIndex)
            
            let section: UICollectionViewCompositionalLayout = layoutFactory.getDynamicLayoutSection(
                xValueRatio(5),
                environment.container.effectiveContentSize.width,
                sectionIndex,
                sectionItem
            )
            
            return section
        }
    }
}

extension CompositionalViewController: UICollectionViewDelegate {
    
}
