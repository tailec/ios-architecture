//
//  GradientImageView.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 30/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import UIKit

final class GradientImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0.1
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).cgColor, UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.9, 1]
        layer.mask = gradient
    }
}
