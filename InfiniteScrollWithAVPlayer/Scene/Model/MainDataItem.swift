//
//  MainDataItem.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import Foundation

enum MainSection: Int, CaseIterable {

    case banner
    case product

}

enum MainItem {

    case banner(BannerMainCellViewModel)
    case product(ProductModel)

}

extension MainItem: Hashable { }

struct MainDataItem {

    let section: MainSection
    let items: [MainItem]

}

extension MainDataItem: Hashable { }


