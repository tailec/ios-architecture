//
//  SearchViewController.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 29/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

final class SearchViewController: DisposeViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
}

extension SearchViewController: StaticFactory {
    enum Factory {
        static var `default`: SearchViewController {
            let vc = R.storyboard.main.searchViewController()!
            let driver = SearchDriver.Factory.default
            let stateBinder = SearchStateBinder.Factory
                .default(vc, driver: driver)
            let actionBinder = SearchActionBinder(viewController: vc,
                                                                driver: driver)
            let navigationBinder = NavigationPushBinder<SearchResultItem, SearchViewController>.Factory
                .push(viewController: vc,
                      driver: driver.didSelect,
                      factory: detailViewControllerFactory)
            vc.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return vc
        }
        
        private static func detailViewControllerFactory(_ item: SearchResultItem) -> UIViewController {
            MovieDetailViewController.Factory.default(id: item.id)
        }
    }
}
