//
//  DiscoverViewControllerBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 04.10.2020.
//

import UIKit

final class DiscoverViewControllerBinder: ViewControllerBinder {
    unowned let viewController: DiscoverViewController
    private let driver: DiscoverDriving
    
    init(viewController: DiscoverViewController,
         driver: DiscoverDriving) {
        self.viewController = viewController
        self.driver = driver
        
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.statusBarStyle = .lightContent
        
        bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: DiscoverViewControllerBinder.viewWillAppear)),
            driver.state
                .drive(onNext: unowned(self, in: DiscoverViewControllerBinder.apply))
        )
        
        let select = viewController.carouselsView
            .selectedIndex
            .asDriver(onErrorJustReturn: (0, 0))
        
        bag.insert(
            select.drive(onNext: driver.select)
        )
    }
    
    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func apply(state: DiscoverState) {
        switch state {
        case .loading, .none:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case let .results(viewModel):
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            viewController.carouselsView.setDataSource(viewModel)
            viewController.carouselsView.reloadData()
        }
    }
}
