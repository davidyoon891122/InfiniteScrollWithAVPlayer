//
//  BannerCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import SnapKit

final class BannerCell: UICollectionViewCell {

    static let identifier: String = String(describing: BannerCell.self)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .label

        return label
    }()


    private lazy var containerView: UIView = {
        let view = UIView()
        [
            self.titleLabel
        ].forEach { view.addSubview($0) }

        self.titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(500.0)
        }


        return view
    }()

    func setData(data: BannerModel) {
        self.setupViews()
        self.titleLabel.text = data.title
        self.containerView.backgroundColor = data.bgColor
    }

}

private extension BannerCell {

    func setupViews() {
        self.contentView.backgroundColor = .systemBackground

        self.contentView.addSubview(self.containerView)

        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}


#Preview {
    BannerCell()
}
