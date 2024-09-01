//
//  ProductModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import UIKit

struct ProductModel: Identifiable, Hashable {

    let id: String
    let name: String
    let description: String
    let price: Double
    let url: URL?
    let bgColor: UIColor

}

extension ProductModel {

    static let items: [Self] = [
        .init(id: UUID().uuidString, name: "Product1", description: "Product1", price: 0.0, url: URL(string: ""), bgColor: .red),
        .init(id: UUID().uuidString, name: "Product2", description: "Product2", price: 0.0, url: URL(string: ""), bgColor: .green)
    ]

}
