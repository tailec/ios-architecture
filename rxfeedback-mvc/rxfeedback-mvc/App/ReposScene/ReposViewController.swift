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
import RxFeedback

fileprivate struct State {
    var query: String
    var results: [Repo]
    var initialFetch: Bool
    var lastSelectedRepoId: Int?
    var shouldFetch: Bool
}

extension State {
    var shouldFetchQuery: String? {
        guard !initialFetch else { return "rxswift" }
        return shouldFetch ? query : nil
    }
}

extension State {
    static var empty: State {
        return State(query: "", results: [], initialFetch: true, lastSelectedRepoId: nil, shouldFetch: false)
    }
    
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .queryChanged(let query):
            var result = state
            result.query = query
            return result
        case .response(let repos):
            var result = state
            result.results = repos
            result.initialFetch = false
            result.shouldFetch = false
            return result
        case .selection(let indexPath):
            var result = state
            result.lastSelectedRepoId = state.results[indexPath.row].id
            return result
        case .shouldFetch:
            var result = state
            result.shouldFetch = true
            return result
        }
    }
}

fileprivate enum Event {
    case queryChanged(String)
    case response([Repo])
    case selection(IndexPath)
    case shouldFetch
}

final class ReposViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let networkingApi = NetworkingApi()
    
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
        
        bindFeedbackLoop()
    }
    
    private func bindFeedbackLoop() {
        let triggerFetch: (Driver<State>) -> Signal<Event> = { state in
            return state
                .map { $0.query }
                .filter { $0.count > 2 }
                .throttle(0.5)
                .distinctUntilChanged()
                .asSignal(onErrorJustReturn: "")
                .map { _ in Event.shouldFetch }
        }
        
        let bindUI: (Driver<State>) -> Signal<Event> = bind(self) { me, state in
            let subscriptions = [
                state.map { $0.query }
                    .drive(me.searchController.searchBar.rx.text),
                state.map { $0.results }
                    .drive(me.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                    cell.textLabel?.text = element.name
                },
                state.map { $0.shouldFetch }
                    .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible),
                state.map { $0.lastSelectedRepoId }
                    .filter { $0 != nil }
                    .map { $0! }
                    .drive(onNext: { repoId in
                        let alertController = UIAlertController(title: "\(repoId)", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        me.present(alertController, animated: true, completion: nil)
                    })
            ]
            
            let events: [Signal<Event>] = [
                me.tableView.rx.itemSelected
                    .asSignal()
                    .map(Event.selection),
                me.searchController.searchBar.rx.text.orEmpty
                    .asSignal(onErrorJustReturn: "")
                    .map(Event.queryChanged),
                triggerFetch(state)
            ]
            
            return Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(initialState: State.empty,
                      reduce: State.reduce,
                      feedback:
                        bindUI,
                        react(request: { $0.shouldFetchQuery }, effects: { query in
                            return self.networkingApi.searchRepos(withQuery: query)
                                .debug(trimOutput: true)
                                .asSignal(onErrorJustReturn: [])
                                .map(Event.response)
                        })
                )
                .drive()
                .disposed(by: disposeBag)
    }
}
