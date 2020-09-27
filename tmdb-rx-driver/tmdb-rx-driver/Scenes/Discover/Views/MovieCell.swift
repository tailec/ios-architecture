//
//  MovieCell.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 28/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet private (set) var imageView: UIImageView!
    @IBOutlet private (set) var titleLabel: UILabel!
    @IBOutlet private (set) var subtitleLabel: UILabel!
    
    private struct Constants {
        static let maxHeight: CGFloat = 400
    }
    
    private static let sizingCell = UINib(nibName: String(describing: MovieCell.self), bundle: nil)
        .instantiate(withOwner: nil, options: nil).first! as! MovieCell

    static func height(forWidth width: CGFloat) -> CGFloat {
        sizingCell.prepareForReuse()
        sizingCell.layoutIfNeeded()
        
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        let size = sizingCell.contentView.systemLayoutSizeFitting(fittingSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow)
        
        guard size.height < Constants.maxHeight else {
            return Constants.maxHeight
        }
        
        return size.height
    }
}
