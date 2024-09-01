//
//  BannerMainCellViewModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 9/1/24.
//

import Foundation
import Combine

struct BannerMainCellViewModel {

    struct Inputs {
        let cellDidLoad: AnyPublisher<Void, Never>
    }

    struct Outputs {
        let item: AnyPublisher<[BannerModel], Never>
        let events: AnyPublisher<Void, Never>
    }

    private let bannerModels: [BannerModel]

    init(bannerModels: [BannerModel]) {
        self.bannerModels = bannerModels
    }

}

extension BannerMainCellViewModel: Hashable {
    
    func bind(_ inputs: Inputs) -> Outputs {
        let items = self.bannerModels

        let itemSubject: PassthroughSubject<[BannerModel], Never> = .init()

        let events = Publishers.MergeMany(
            inputs.cellDidLoad
                .map {
                    itemSubject.send(items)
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()


        return .init(item: itemSubject.eraseToAnyPublisher(), events: events)
    }

}
