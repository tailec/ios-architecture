//
//  MovieDetailNavigator.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

protocol MovieDetailNavigatable {
    func goBack()
}

final class MovieDetailNavigator: MovieDetailNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
