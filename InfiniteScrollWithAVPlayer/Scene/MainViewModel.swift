//
//  MainViewModel.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import Foundation

struct MainViewModel {

    struct Inputs {

    }

    struct Outputs {

    }

    private let navigator: MainViewNavigatorProtocol

    init(navigator: MainViewNavigatorProtocol) {
        self.navigator = navigator
    }

}

extension MainViewModel {

    func bind(_ inputs: Inputs) -> Outputs {
        return .init()
    }
}
