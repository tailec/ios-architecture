//
//  DiscoverViewController.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class DiscoverViewController: DisposeViewController {
    @IBOutlet private (set) var carouselsView: DiscoverMainView!
}

extension DiscoverViewController: StaticFactory {
    enum Factory {
        static var `default`: DiscoverViewController {
            let vc = UIStoryboard.main.discoverViewController
            let driver = DiscoverDriver(api: TMDBApi.Factory.default)
            let binder = DiscoverViewControllerBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPushBinder<DiscoverSelection, DiscoverViewController>.Factory
                .push(viewController: vc,
                      driver: driver.didSelect,
                      factory: viewControllerFactory)
            
            vc.bag.insert(
                binder,
                navigationBinder
            )
            return vc
        }
        
        private static func viewControllerFactory(selection: DiscoverSelection) -> UIViewController? {
            switch selection.item {
            case .movie:
                return MovieDetailViewController.Factory.default(id: selection.index)
            case .person, .show:
                return nil
            }
        }
    }
}
