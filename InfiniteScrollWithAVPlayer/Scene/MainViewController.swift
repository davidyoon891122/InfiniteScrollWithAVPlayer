//
//  MainViewController.swift
//  InfiniteScrollWithAVPlayer
//
//  Created by Jiwon Yoon on 8/31/24.
//

import UIKit

final class MainViewController: UIViewController {

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }

}


#Preview {
    MainViewController(viewModel: MainViewModel(navigator: MainViewNavigator(navigationController: UINavigationController())))
}
