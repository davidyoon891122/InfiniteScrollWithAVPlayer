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

typealias BannerIndexInfo = (currentIndex: Int, itemsCount: Int)

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
    
    private var currentCenterIndexPath: IndexPath?


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


            section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
                guard let currentIndex = visibleItems.last?.indexPath.row,
                      visibleItems.last?.indexPath.section == 0,
                      let self = self else { return }
                        
                self.willChangeMainSectionIndex(currentIndex: currentIndex)
                
                let centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.width / 2
                let centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.height / 2
                let centerPoint = CGPoint(x: centerX, y: centerY)

                self.currentCenterIndexPath = self.collectionView.indexPathForItem(at: centerPoint)
            }

            return section
        })
    }

    func applySnapshot(data: [BannerModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<BannerSection, BannerModel>()
        snapshot.appendSections(BannerSection.allCases)
        snapshot.appendItems(data, toSection: .banner)

        self.dataSource.apply(snapshot, animatingDifferences: true) {
            self.collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .left, animated: false)
        }

    }
    
    func willChangeMainSectionIndex(currentIndex: Int) {
        let startTriggerIndex = 2 - 1  //     8 인덱스
        let endTriggerIndex = 2 * 2 + 1  // 7 인덱스
        let middleLastIndex = 2 * 2 - 1  // 5 인덱스
        let middleStartIndex = 2 // 9 인덱스

        switch currentIndex {
        case startTriggerIndex:
            self.collectionView.scrollToItem(
                at: [0, middleLastIndex],
                at: .right,
                animated: false
            )
        case endTriggerIndex:
            self.collectionView.scrollToItem(
                at: [0, middleStartIndex],
                at: .left,
                animated: false
            )
        default:
            if let cell = self.collectionView.cellForItem(at: .init(row: currentIndex, section: 0)) as? BannerCell {
                //cell.play()
            }
            break
        }
    }

}

private extension BannerMainCell {
    
    enum Constants {
        static let bannerSection: Int = 0
        static let bannerPageControlTopConstraint: CGFloat = 548.0
        static let bannerPageControlLeadingConstraint: CGFloat = 20.0
    }
    
}

@available(iOS 17.0, *)
#Preview {
    BannerMainCell()
}
