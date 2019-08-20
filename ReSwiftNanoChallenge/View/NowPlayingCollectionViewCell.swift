//
//  NowPlayingCollectionViewCell.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 18/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.moviePoster.layer.cornerRadius = 10
        self.moviePoster.layer.masksToBounds = true
    }
    
    func set(image: Data, title: String, rate: String) {
        self.moviePoster.image = UIImage(data: image)
        self.movieTitle.text = title
        self.movieRate.text = rate
    }
}
