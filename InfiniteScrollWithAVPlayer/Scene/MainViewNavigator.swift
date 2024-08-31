//
//  MainViewNavigator.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import UIKit

protocol MainViewNavigatorProtocol {

    func toMain()

}

struct MainViewNavigator {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}

extension MainViewNavigator: MainViewNavigatorProtocol {

    func toMain() {
        let viewModel = MainViewModel(navigator: self)
        let viewController = MainViewController(viewModel: viewModel)

        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
