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
    private var layoutFactory = CompositionalLayoutFactory()
    private var cancellable: Set<AnyCancellable> = .init()
    private lazy var compositionalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
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
        compositionalCollectionView.delegate = self
        compositionalCollectionView.register(CompositionalCollectionViewCell.self,
                                forCellWithReuseIdentifier: CompositionalCollectionViewCell.identifier)
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
                case .showDetailView(selectedIndex: _,
                                     contents: _):
                    break
                case .showLoading:
                    break
                case .hideLoading:
                    break
                case .invalidateLayout:
                    self?.invalidateLayout()
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
    
    
    // MARK: 여기가 문제
    private func setDataSource() {
        dataSource = .init(collectionView: compositionalCollectionView) { [weak self] in
            guard let strongSelf = self else {
                return $0.dequeueReusableCell(withReuseIdentifier: "cell", for: $1)
            }
            
            if let cell = $0.dequeueReusableCell(withReuseIdentifier: CompositionalCollectionViewCell.identifier, for: $1) as? CompositionalCollectionViewCell,
               let item = $2 as? CompositionalCellItem {
                
                cell.configure(item)
                return cell
            }
            

            return $0.dequeueReusableCell(withReuseIdentifier: "cell", for: $1)
        }
    }
    
    private func invalidateLayout() {
        if let visibleIndexPaths = compositionalCollectionView.indexPathsForVisibleItems.min(by: { $0.item < $1.item }),
              visibleIndexPaths.isEmpty == false {
            
            compositionalCollectionView.reloadData()
            
            
            compositionalCollectionView.scrollToItem(at: visibleIndexPaths, at: .top, animated: false)
        } else{
            compositionalCollectionView.reloadData()
        }
    }
    
}

extension CompositionalViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            
            guard let sectionItem = self?.viewModel.getSectionItem(sectionIndex) else {
                return self?.layoutFactory.getEmptySection()
            }
            
            let numberOfItem = sectionItem.items.count

            let section = self?.layoutFactory.getDynamicLayoutSection(
                2,
                self?.xValueRatio(5) ?? 0,
                environment.container.effectiveContentSize.width,
                numberOfItem,
                sectionItem
            )

            return section
        }
    }
}

extension CompositionalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.action(.willDisplay(indexPath))
    }
}
