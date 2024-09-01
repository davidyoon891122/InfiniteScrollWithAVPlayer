//
//  BannerModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit

struct BannerModel: Identifiable, Hashable {

    let id: String
    let title: String
    let url: URL?
    let bgColor: UIColor

}

extension BannerModel {

    static let items: [Self] = [
        .init(id: UUID().uuidString, title: "First", url: URL(string: ""), bgColor: .cyan),
        .init(id: UUID().uuidString, title: "Second", url: URL(string: ""), bgColor: .purple)
    ]

}
