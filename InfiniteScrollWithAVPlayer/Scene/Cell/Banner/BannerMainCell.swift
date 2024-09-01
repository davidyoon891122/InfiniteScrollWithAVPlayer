//
//  BannerMainCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

enum BannerSection: Int, CaseIterable {

    case banner

}

final class BannerMainCell: UICollectionViewCell {

    // Subjects
    private let cellDidLoad: PassthroughSubject<Void, Never> = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    static let identifier: String = String(describing: BannerMainCell.self)


    private lazy var collectionView: UICollectionView = {
        let layout = self.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)

        return collectionView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()

        [
            self.collectionView
        ].forEach { view.addSubview($0) }

        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(500.0)
        }

        return view
    }()


    private lazy var dataSource: UICollectionViewDiffableDataSource<BannerSection, BannerModel> = {
        .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else { return UICollectionViewCell() }

            cell.setData(data: item)
            
            return cell
        })
    }()

    private var isMovedInfinitedScroll: Bool = false


    func setupData(viewModel: BannerMainCellViewModel) {
        self.setupView()
        let outputs = viewModel.bind(.init(
            cellDidLoad: self.cellDidLoad.eraseToAnyPublisher()
        ))

        [
            outputs.item
                .sink(receiveValue: { [weak self] items in
                    self?.applySnapshot(data: items)
                }),
            outputs.events
                .sink(receiveValue: { _ in })
        ].forEach { self.cancellables.insert($0) }

        self.cellDidLoad.send()

    }

}

private extension BannerMainCell {

    func setupView() {
        self.contentView.backgroundColor = .systemBackground

        self.contentView.addSubview(self.containerView)

        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        .init(sectionProvider: { sectionIndex, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500.0)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500.0)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered


            section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in


            }

            return section
        })
    }

    func applySnapshot(data: [BannerModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<BannerSection, BannerModel>()
        snapshot.appendSections(BannerSection.allCases)
        snapshot.appendItems(data, toSection: .banner)

        self.dataSource.apply(snapshot, animatingDifferences: true)

    }

    func scrollToInitialPosition(in section: Int) {
        let itemsCount = self.collectionView.numberOfItems(inSection: section) / 3
        let initialIndexPath = IndexPath(item: itemsCount, section: section)
        self.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
    }

}

#Preview {
    BannerMainCell()
}
