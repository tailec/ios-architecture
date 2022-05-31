//
//  MovieDetailTipsView.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 29/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

final class MovieDetailTipsView: UIView {
    @IBOutlet private(set) var voteCountLabel: UILabel!
    @IBOutlet private(set) var statusLabel: UILabel!
    @IBOutlet private(set) var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(withVoteCount voteCount: String,
                   status: String) {
        self.voteCountLabel.text = voteCount
        self.statusLabel.text = status
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("MovieDetailTipsView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}

extension MovieDetailTipsView {
    func configure(with data: MovieDetailData) {
        configure(withVoteCount: data.voteCount,
                  status: data.status)
    }
}
