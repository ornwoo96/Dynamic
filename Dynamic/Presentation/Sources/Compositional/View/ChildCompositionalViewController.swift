//
//  Child.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import UIKit
import Combine

class ChildCompositionalViewController: UIViewController, HasCoordinatable {
    private let viewModel: ChildCompositionalViewModelProtocol
    var coordinator: Coordinator?
    private var castedCoordinator: ChildCompositionalCoordinator? { coordinator as? ChildCompositionalCoordinator }
    private var layoutFactory = CompositionalLayoutFactory()
    private var cancellable: Set<AnyCancellable> = .init()
    private lazy var compositionalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
    private var dataSource: UICollectionViewDiffableDataSource<ChildCompositionalViewModel.Section, BaseCellItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        setupLongGestureRecognizerOnCollection()
        setupUI()
        bind()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    init(viewModel: ChildCompositionalViewModelProtocol,
         category: ChildCompositionalViewModel.Category) {
        self.viewModel = viewModel
        self.viewModel.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupViewController()
        setupCollectionView()
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
    }
    
    private func setupCollectionView() {
        registerCollectionViewCell()
        compositionalCollectionView.contentInset = UIEdgeInsets(top: yValueRatio(10), left: .zero, bottom: .zero, right: .zero)
        compositionalCollectionView.backgroundColor = .clear
        compositionalCollectionView.delegate = self
        view.addSubview(compositionalCollectionView)
        compositionalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compositionalCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            compositionalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compositionalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            compositionalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCollectionViewCell() {
        compositionalCollectionView.register(CompositionalCollectionViewCell.self,
                                             forCellWithReuseIdentifier: CompositionalCollectionViewCell.identifier)
        compositionalCollectionView.register(CompositionalHeaderView.self,
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                             withReuseIdentifier: CompositionalHeaderView.identifier)
    }
    
    private func bind() {
        bindEvent()
    }
    
    private func bindEvent() {
        viewModel.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let strongSelf = self else { return }
                switch $0 {
                case .none:
                    break
                case .reloadData(sections: let sections):
                    strongSelf.reloadData(sections)
                case .showDetailView(let data):
                    strongSelf.showDetailView(data)
                case .showLoading:
                    break
                case .hideLoading:
                    break
                case .invalidateLayout:
                    strongSelf.invalidateLayout()
                case .showHeartView(indexPath: let indexPath):
                    strongSelf.setupCellWhenCellLongPressed(indexPath)
                case .animateHideBar:
                    strongSelf.animateHideBar()
                case .animateShowBar:
                    strongSelf.animateShowBar()
                }
            }
            .store(in: &cancellable)
    }
    
    private func reloadData(_ sections: [ChildCompositionalViewModel.Section]) {
        var snapShot = NSDiffableDataSourceSnapshot<ChildCompositionalViewModel.Section, BaseCellItem>()
        
        sections.forEach {
            snapShot.appendSections([$0])
            snapShot.appendItems($0.items, toSection: $0)
        }
        dataSource?.apply(snapShot)
    }
    
    private func setDataSource() {
        dataSource = .init(collectionView: compositionalCollectionView) { [weak self] in
            let sectionType = self?.viewModel.getSectionItem($1.section).type
            switch sectionType {
            case .content:
                if let cell = $0.dequeueReusableCell(withReuseIdentifier: CompositionalCollectionViewCell.identifier,
                                                     for: $1) as? CompositionalCollectionViewCell,
                   let item = $2 as? CompositionalCellItem {
                    
                    cell.configure(item)
                    return cell
                }
            case .none: break
            }
            return $0.dequeueReusableCell(withReuseIdentifier: "cell", for: $1)
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let view = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: CompositionalHeaderView.identifier,
                                                  for: indexPath)
            view.viewRadius(cornerRadius: 20)
            return view
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
    
    private func showDetailView(_ data: DetailModel) {
        castedCoordinator?.presentDetailView(self, data)
    }
    
}

extension ChildCompositionalViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let sectionItem = self?.viewModel.getSectionItem(sectionIndex) else {
                return (self?.layoutFactory.getEmptySection())!
            }
            
            let numberOfItem = sectionItem.items.count
            
            let section = self?.layoutFactory.getDynamicLayoutSection(
                columnCount: 2,
                itemPadding: 10,
                contentWidth: environment.container.effectiveContentSize.width,
                sectionIndex: sectionIndex,
                numberOfItems: numberOfItem,
                sectionItem: sectionItem
            )
            
            return section
        }
    }
}

extension ChildCompositionalViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.action(.scrollViewDidScroll(scrollView.contentOffset.y))
    }
}

extension ChildCompositionalViewController {
    
    private func animateHideBar() {
        print("hideBar")
        castedCoordinator?.hideNavigationBar()
    }
    
    private func animateShowBar() {
        print("showBar")
        castedCoordinator?.showNavigationBar()
    }
}

extension ChildCompositionalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.didSelectItemAt(indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.action(.willDisplay(indexPath))
    }
}

extension ChildCompositionalViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(LongPressCell(_:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        compositionalCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func LongPressCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            viewModel.action(.didSelectedItemAtLongPressed(indexPath: findLongPressCellIndexPath(gestureRecognizer)))
        }
    }

    private func findLongPressCellIndexPath(_ gestureRecognizer: UILongPressGestureRecognizer) -> IndexPath {
        let location = gestureRecognizer.location(in: compositionalCollectionView)
        guard let indexPath = compositionalCollectionView.indexPathForItem(at: location) else { return IndexPath() }
        
        return indexPath
    }

    private func setupCellWhenCellLongPressed(_ indexPath: IndexPath) {
        guard let cell = compositionalCollectionView.cellForItem(at: indexPath) as? CompositionalCollectionViewCell else { return }
        
        viewModel.checkFavoriteButtonTapped(cell.checkHeartViewIsHidden(), indexPath.item)
    }
}
