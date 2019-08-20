//
//  SeeAllCollectionViewCell.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 20/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class SeeAllCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(imageData: Data, title: String, rate: Double) {
        self.poster.image = UIImage(data: imageData)
        self.title.text = title
        self.rate.text = String(rate)
    }
}
