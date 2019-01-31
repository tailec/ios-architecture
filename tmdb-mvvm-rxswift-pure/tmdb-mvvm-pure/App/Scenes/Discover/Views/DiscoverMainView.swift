
//
//  CarouselVIew.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit
import Nuke
import RxSwift
import RxCocoa

final class DiscoverMainView: UIView {
    private var dataSource: [CarouselViewModel]?
    private var storedOffsets = [Int: CGFloat]()
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private let selectedIndexSubject = PublishSubject<(Int, Int)>()
    var selectedIndex: Observable<(Int, Int)> {
        return selectedIndexSubject.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        tableView.register(UINib(nibName: String(describing: CarouselSectionCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CarouselSectionCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setDataSource(_ dataSource: [CarouselViewModel]) {
        self.dataSource = dataSource
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(String(describing: DiscoverMainView.self), owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension DiscoverMainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = dataSource else { return UITableViewCell() } // No-op
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CarouselSectionCell.self),
                                                 for: indexPath) as! CarouselSectionCell
        let carouselData = data[indexPath.row]
        cell.titleLabel.text = carouselData.title
        cell.subtitleLabel.text = carouselData.subtitle
        return cell
    }
}

extension DiscoverMainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CarouselSectionCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CarouselSectionCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension DiscoverMainView :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexSubject.onNext((collectionView.tag, indexPath.item))
    }
}

extension DiscoverMainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[collectionView.tag].items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = dataSource else { return UICollectionViewCell() } // No-op
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as! MovieCell
        let item = data[collectionView.tag].items[indexPath.item]
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
        if let url = item.imageUrl {
            Nuke.loadImage(with: URL(string: url)!, into: cell.imageView)
        }
        return cell
    }
}

extension DiscoverMainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let width = collectionView.bounds.width / itemsPerRow
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
