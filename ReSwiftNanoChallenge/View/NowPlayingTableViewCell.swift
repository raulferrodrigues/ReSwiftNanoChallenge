//
//  NowPlayingTableViewCell.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {

    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NowPlayingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        return cell
    }
}
