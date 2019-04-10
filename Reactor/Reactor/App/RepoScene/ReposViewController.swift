//
//  ViewController.swift
//  MVVMPureObservables
//
//  Created by krawiecp-home on 24/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ReposViewController: UIViewController, View {
    private let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    private let searchTextField = UITextField()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = nil
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func bind(reactor: ReposReactor) {
        reactor.state.map{$0.loading}
            .distinctUntilChanged()
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.respoViewModels}
            .distinctUntilChanged()
            .bind(to:tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.selectedRepoId}
            .filter{$0 != nil}
            .map{$0!}
            .subscribe(onNext: { [weak self] repoId in
                guard let strongSelf = self else { return }
                let alertController = UIAlertController(title: "\(repoId)", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                strongSelf.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        //MARK: - Action
        rx.viewWillAppear
            .map{ReposReactor.Action.ready}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{ReposReactor.Action.selected(index: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map{ReposReactor.Action.search(text: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
