//
//  BannerMainCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import SnapKit

final class BannerMainCell: UICollectionViewCell {

    static let identifier: String = String(describing: BannerMainCell.self)


    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .label

        return label
    }()


    private lazy var containerView: UIView = {
        let view = UIView()

        [
            self.titleLabel
        ].forEach { view.addSubview($0) }

        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(500.0)
        }

        return view
    }()


    func setupData() {

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

}

#Preview {
    BannerMainCell()
}
