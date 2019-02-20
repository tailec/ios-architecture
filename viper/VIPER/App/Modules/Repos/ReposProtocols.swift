//
//  ReposProtocols.swift
//  VIPER
//
//  Created by krawiecp-home on 19/02/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

protocol ReposViewType: class {
    var presenter: ReposPresenterType? { get set }
    func didReceiveRepos()
    func showLoading()
    func hideLoading()
    func displayAlert(for id: Int)
}

protocol ReposWireframeType: class {
    static func createReposModule() -> UIViewController
}

protocol ReposPresenterType: class {
    var view: ReposViewType? { get set }
    var interactor: ReposInteractorInputsType? { get set }
    var wireframe: ReposWireframeType? { get set }
    
    func onViewDidLoad()
    func didChangeQuery(_ query: String?)
    func didSelectRow(_ indexPath: IndexPath)
    
    func numberOfListItems() -> Int
    func listItem(at index: Int) -> RepoViewModel
}

protocol ReposInteractorInputsType: class {
    var presenter: ReposInteractorOutputsType? { get set }
    func fetchRepos(for query: String)
    func fetchInitialRepos()
}

protocol ReposInteractorOutputsType: class {
    func didRetrieveRepos(_ repos: [Repo])
}

protocol ReposRemoteDataManagerType: class {
    func fetchRepos(for query: String, completion: @escaping ([Repo]) -> ())
}

