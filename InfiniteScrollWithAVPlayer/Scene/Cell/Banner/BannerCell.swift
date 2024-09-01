//
//  BannerCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import SnapKit
import AVKit

final class BannerCell: UICollectionViewCell {

    static let identifier: String = String(describing: BannerCell.self)

    private lazy var avPlayer: AVPlayer = {
        let avPlayer = AVPlayer()

        return avPlayer
    }()

    private lazy var avPlayerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: self.avPlayer)
        layer.videoGravity = .resize

        return layer
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.addSublayer(self.avPlayerLayer)

        return view
    }()

    func setData(data: BannerModel) {
        self.setupViews()
        if let url = data.url {
            let item = AVPlayerItem(url: url)
            self.avPlayer.replaceCurrentItem(with: item)
        }
        self.avPlayer.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avPlayerLayer.frame = self.contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.avPlayer.replaceCurrentItem(with: nil)
    }

}

private extension BannerCell {

    func setupViews() {
        self.contentView.backgroundColor = .systemBackground

        self.contentView.addSubview(self.containerView)

        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(500.0)
        }
    }

}

@available(iOS 17.0, *)
#Preview {
    let cell = BannerCell()
    cell.setData(data: .items[0])
    
    return cell
}
