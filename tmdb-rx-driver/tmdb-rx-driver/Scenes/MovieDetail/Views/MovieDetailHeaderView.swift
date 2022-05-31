//
//  MovieDetailHeaderView.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

final class MovieDetailHeaderView: UIView {
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var releaseDateLabel: UILabel!
    @IBOutlet private(set) var genresLabel: UILabel!
    @IBOutlet private(set) var runtimeLabel: UILabel!
    @IBOutlet private(set) var voteAverageLabel: UILabel!
    @IBOutlet private(set) var overviewLabel: UILabel!
    @IBOutlet private(set) var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(withTitle title: String,
                   releaseDate: String,
                   genres: String,
                   runtime: String,
                   voteAverage: String,
                   overview: String) {
        titleLabel.text = title
        releaseDateLabel.text = releaseDate
        genresLabel.text = genres
        runtimeLabel.text = runtime
        voteAverageLabel.text = voteAverage
        overviewLabel.text = overview
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("MovieDetailHeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}

extension MovieDetailHeaderView {
    func configure(with data: MovieDetailData) {
        configure(withTitle: data.title,
                  releaseDate: data.releaseDate,
                  genres: data.genres,
                  runtime: data.runtime,
                  voteAverage: data.voteAverage,
                  overview: data.overview)
    }
}
