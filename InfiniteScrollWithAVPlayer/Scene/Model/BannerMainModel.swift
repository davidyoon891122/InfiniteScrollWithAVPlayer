//
//  BannerMainModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import Foundation

struct BannerMainModel: Identifiable, Hashable {

    let id: String

}

extension BannerMainModel {

    static let item: [Self] = [.init(id: UUID().uuidString)]

}
