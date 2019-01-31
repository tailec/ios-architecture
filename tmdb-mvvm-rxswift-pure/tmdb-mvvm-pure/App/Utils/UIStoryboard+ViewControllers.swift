//
//  UIStoryboard+ViewControllers.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 27/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension UIStoryboard {
    var loginViewController: LoginViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            fatalError("LoginViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var discoverViewController: DiscoverViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DiscoverViewController") as? DiscoverViewController else {
            fatalError("DiscoverViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var movieDetailViewController: MovieDetailViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            fatalError("MovieDetailViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var searchViewController: SearchViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            fatalError("SearchViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
