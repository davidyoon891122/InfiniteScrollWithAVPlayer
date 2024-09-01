//
//  MainViewModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import Foundation
import Combine

struct MainViewModel {

    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Outputs {
        let item: AnyPublisher<[MainDataItem], Never>
        let events: AnyPublisher<Void, Never>
    }

    private let navigator: MainViewNavigatorProtocol

    init(navigator: MainViewNavigatorProtocol) {
        self.navigator = navigator
    }

}

extension MainViewModel {

    func bind(_ inputs: Inputs) -> Outputs {

        let itemSubject: PassthroughSubject<[MainDataItem], Never> = .init()

        let events = Publishers.MergeMany(
            inputs.viewDidLoad
                .map {
                    print("ViewDidLoad")

                    let infinitedFrontItems = BannerModel.items.map { $0.infinitedModel }
                    let infinitedBackItems = BannerModel.items.map { $0.infinitedModel }
                    let productItems = ProductModel.items.map { MainDataItem(section: .product, items: [.product($0)])}
                    let bannerItems = infinitedFrontItems + BannerModel.items + infinitedBackItems

                    itemSubject.send([
                        .init(section: .banner, items: [.banner(BannerMainCellViewModel(bannerModels: bannerItems))])
                    ] + productItems)
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()

        return .init(item: itemSubject.eraseToAnyPublisher(), events: events)
    }
}
