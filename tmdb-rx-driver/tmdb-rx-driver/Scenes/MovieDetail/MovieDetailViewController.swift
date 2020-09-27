//
//  MovieDetailViewController.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit
import RxSwift

final class MovieDetailViewController: DisposeViewController {
    @IBOutlet private(set) var headerView: MovieDetailHeaderView!
    @IBOutlet private(set) var tipsView: MovieDetailTipsView!
    @IBOutlet private(set) var posterImageView: GradientImageView!
    @IBOutlet private(set) var backButton: UIButton!
}

extension MovieDetailViewController: StaticFactory {
    enum Factory {
        static func`default`(id: Int) -> MovieDetailViewController {
            let vc = R.storyboard.main.movieDetailViewController()!
            let driver = MovieDetailDriver.Factory.default(id: id)
            let stateBinder = MovieDetailStateBinder(viewController: vc, driver: driver)
            let actionBinder = MovieDetailActionBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPopBinder<MovieDetailViewController>.Factory
                .pop(viewController: vc, driver: driver.didClose)
            vc.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return vc
        }
    }
}
