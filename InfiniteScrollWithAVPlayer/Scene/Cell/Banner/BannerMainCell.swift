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
    private let scrollDidStart: PassthroughSubject<IndexPath, Never> = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    static let identifier: String = String(describing: BannerMainCell.self)


    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 500.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

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

extension BannerMainCell: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleInfiniteScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.handleInfiniteScroll(scrollView)
    }
    
    private func handleInfiniteScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)

        if currentPage == 0 {
            self.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: false)
        } else if currentPage == 5 {
            self.collectionView.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
            print("Begin Dragging: \(indexPath.row)")
            self.scrollDidStart.send(indexPath)
            
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? BannerCell else { return }
            cell.pause()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let bannerCell = cell as? BannerCell else { return }
        print("will displayed IndexPath: \(indexPath.row)")
        bannerCell.play()
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


    func applySnapshot(data: [BannerModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<BannerSection, BannerModel>()
        snapshot.appendSections(BannerSection.allCases)
        snapshot.appendItems(data, toSection: .banner)

        self.dataSource.apply(snapshot, animatingDifferences: true) {
            self.collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .left, animated: false)
        }

    }

}

@available(iOS 17.0, *)
#Preview {
    BannerMainCell()
}
