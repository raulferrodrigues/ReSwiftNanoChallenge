//
//  PopularTableViewCell.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 18/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var movieRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.moviePoster.layer.cornerRadius = 10
        self.moviePoster.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(image: Data, title: String, overview: String, rate: String) {
        self.moviePoster.image = UIImage(data: image)
        self.movieTitle.text = title
        self.movieOverview.text = overview
        self.movieRate.text = rate
    }
    
    override func prepareForReuse() {
        moviePoster.image = nil
    }
    
}
