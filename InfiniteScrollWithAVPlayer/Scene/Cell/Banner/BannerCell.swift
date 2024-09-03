//
//  BannerCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import SnapKit
import AVKit
import Kingfisher

final class BannerCell: UICollectionViewCell {

    static let identifier: String = String(describing: BannerCell.self)
    
    private lazy var thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = false
        
        return imageView
    }()

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
        
        view.addSubview(self.thumbNailImageView)
        
        self.thumbNailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return view
    }()

    func setData(data: BannerModel) {
        self.setupViews()
        if let url = data.url {
            self.thumbNailImageView.isHidden = false
            let asset = AVAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            self.avPlayer.replaceCurrentItem(with: item)
            self.thumbNailImageView.kf.setImage(with: data.imageURL)
            self.play()
        }
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avPlayerLayer.frame = self.contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.avPlayer.replaceCurrentItem(with: nil)
        self.avPlayer.seek(to: .zero)
        self.avPlayerLayer.frame = .zero
        self.thumbNailImageView.kf.cancelDownloadTask()
        self.thumbNailImageView.image = nil
        self.thumbNailImageView.isHidden = false
    }
    
    func play() {
        print("Play")
        self.avPlayer.pause()
        self.avPlayer.seek(to: .zero)
        self.avPlayer.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.thumbNailImageView.isHidden = true
        }
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
