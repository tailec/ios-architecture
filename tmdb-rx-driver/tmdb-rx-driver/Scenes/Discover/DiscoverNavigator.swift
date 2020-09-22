//
//  DiscoverNavigator.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

protocol DiscoverNavigatable {
    func navigateToMovieDetailScreen(withMovieId id: Int, api: TMDBApiProvider)
    func navigateToPersonDetailScreen()
    func navigateToShowDetailScreen()
}

final class DiscoverNavigator: DiscoverNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToMovieDetailScreen(withMovieId id: Int, api: TMDBApiProvider) {
        navigationController.show(MovieDetailViewController.Factory.default(id: id), sender: nil)
    }
    
    func navigateToPersonDetailScreen() {
        
    }
    
    func navigateToShowDetailScreen() {
        
    }
}
