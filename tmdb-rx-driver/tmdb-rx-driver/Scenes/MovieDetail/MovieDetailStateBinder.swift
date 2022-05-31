//
//  MovieDetailStateBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 22.09.2020.
//

import Foundation
import Nuke

final class MovieDetailStateBinder: ViewControllerBinder {
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
        viewController.statusBarStyle = .lightContent
        
        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: MovieDetailStateBinder.viewWillAppear)),
            driver.data
                .drive(onNext: unowned(self, in: MovieDetailStateBinder.configure))
        )
    }
    
    private func configure(_ data: MovieDetailData) {
        viewController.headerView.configure(with: data)
        viewController.tipsView.configure(with: data)
        if let url = data.posterUrl {
            Nuke.loadImage(with: URL(string: url)!, into: viewController.posterImageView)
        }
    }
    
    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
