//
//  MovieDetailActionBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 22.09.2020.
//

import Foundation

final class MovieDetailActionBinder: ViewControllerBinder {
    unowned let viewController: MovieDetailViewController
    private let driver: MovieDetailDriving
    
    init(viewController: MovieDetailViewController,
         driver: MovieDetailDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.bag.insert(
            viewController.backButton.rx.tap
                .bind(onNext: driver.close)
        )
    }
}
