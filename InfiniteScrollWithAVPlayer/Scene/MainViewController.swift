//
//  MainViewController.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

final class MainViewController: UIViewController {

    // Subjects
    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerMainCell.self, forCellWithReuseIdentifier: BannerMainCell.identifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)

        return collectionView
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<MainSection, MainItem> = {
        .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .banner:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerMainCell.identifier, for: indexPath) as? BannerMainCell else { return UICollectionViewCell() }

                cell.setupData()

                return cell
            case .product(let product):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }

                cell.setupData(data: product)
                return cell
            }
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.bindViewModel()

        self.viewDidLoadSubject.send()
    }

}

private extension MainViewController {

    func setupViews() {
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(viewDidLoad: self.viewDidLoadSubject.eraseToAnyPublisher()))

        [
            outputs.item
                .sink(receiveValue: { [weak self] items in
                    self?.applySnapshot(data: items)
                }),
            outputs.events
                .sink(receiveValue: { _ in })
        ].forEach { self.cancellables.insert($0) }

    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        .init(sectionProvider: { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case MainSection.banner.rawValue:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500.0)))

                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500.0)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                return section
            case MainSection.product.rawValue:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0)))

                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                return section
            default:
                return nil
            }
        })
    }

    func applySnapshot(data: [MainDataItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, MainItem>()
        snapshot.appendSections(MainSection.allCases)

        data.forEach {
            snapshot.appendItems($0.items, toSection: $0.section)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

}


#Preview {
    MainViewController(viewModel: MainViewModel(navigator: MainViewNavigator(navigationController: UINavigationController())))
}
