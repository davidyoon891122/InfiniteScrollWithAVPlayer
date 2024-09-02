//
//  BannerCell.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit
import SnapKit
import Player

final class BannerCell: UICollectionViewCell {

    static let identifier: String = String(describing: BannerCell.self)
    
    
    private lazy var player: Player = {
        let player = Player()
        player.fillMode = .resizeAspectFill
        player.playbackLoops = true
        
        return player
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(self.player.view)

        return view
    }()

    func setData(data: BannerModel) {
        self.setupViews()
        self.player.url = data.url
        self.player.playFromBeginning()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.player.view.frame = contentView.bounds
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.player.pause()
        self.player.url = nil
        
    }
    
    deinit {
        self.player.pause()
        self.player.url = nil
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
