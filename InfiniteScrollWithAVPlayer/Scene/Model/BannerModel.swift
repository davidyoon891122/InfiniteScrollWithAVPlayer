//
//  BannerModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit

struct BannerModel: Identifiable, Hashable {

    var id: String
    let title: String
    let url: URL?
    let bgColor: UIColor

}

extension BannerModel {

    static let items: [Self] = [
        .init(id: UUID().uuidString, title: "First", url: URL(string: "https://dywhtlvtiow1a.cloudfront.net/outputs/jeju_cbr.m3u8"), bgColor: .cyan),
        .init(id: UUID().uuidString, title: "Second", url: URL(string: "https://dywhtlvtiow1a.cloudfront.net/outputs/refik+anadol_cbr.m3u8"), bgColor: .purple)
    ]

    var infinitedModel: Self {
        var infinitedModel = self
        infinitedModel.id = UUID().uuidString
        return infinitedModel
    }

}
