//
//  SearchViewControllerBinder.swift
//  tmdb-rx-driver
//
//  Created by Dmytro Shulzhenko on 20.09.2020.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class SearchStateBinder: ViewControllerBinder {
    typealias Item = SearchResultItem
    
    struct Section: SectionModelType {
        let items: [Item]
        
        init(items: [Item]) {
            self.items = items
        }
        
        init(original: Self, items: [Item]) {
            self.items = items
        }
    }
    
    unowned let viewController: SearchViewController
    private let driver: SearchDriving
    private let dataSource: RxTableViewSectionedReloadDataSource<Section>
    private let cell = R.nib.searchCell
    
    init(viewController: SearchViewController,
         driver: SearchDriving,
         dataSource: RxTableViewSectionedReloadDataSource<Section>) {
        self.viewController = viewController
        self.driver = driver
        self.dataSource = dataSource
        
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        viewController.statusBarStyle = .lightContent
        viewController.tableView.register(cell)
        
        let section = driver.results.map(Section.init).map({ [$0] })
        
        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: SearchStateBinder.viewWillAppear)),
            driver.isSwitchHidden
                .drive(viewController.segmentedControl.rx.isHidden),
            driver.isLoading
                .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible),
            section.drive(viewController.tableView.rx.items(dataSource: dataSource))
        )
    }
    
    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension SearchStateBinder: StaticFactory {
    enum Factory {
        static func `default`(_ viewController: SearchViewController,
                              driver: SearchDriving) -> SearchStateBinder {
            let dataSource = RxTableViewSectionedReloadDataSource(configureCell: cellFactory)
            return SearchStateBinder(viewController: viewController,
                                                   driver: driver,
                                                   dataSource: dataSource)
        }
    }

    private static func cellFactory(_: TableViewSectionedDataSource<Section>,
                                    tableView: UITableView,
                                    indexPath: IndexPath,
                                    item: Section.Item) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchCell,
                                                 for: indexPath)!
        cell.configure(withSearchResultItem: item)
        return cell
    }
}
