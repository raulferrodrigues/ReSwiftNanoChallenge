//
//  SeeAllViewController.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 20/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit
import ReSwift

class SeeAllViewController: UIViewController {

    @IBOutlet weak var showingLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var nowPlayingMovies: [Result] = []
    var posters: [String: Data?] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select {
                $0.nowPlayingState
            }
        }
    }

}

extension SeeAllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! SeeAllCollectionViewCell
        let title = nowPlayingMovies[indexPath.row].title ?? ""
        let rate = nowPlayingMovies[indexPath.row].voteAverage ?? 0
        let posterPath = nowPlayingMovies[indexPath.row].posterPath
        let posterData = posters[posterPath!]
        cell.set(imageData: posterData!!, title: title, rate: rate)
        return cell
    }
}

extension SeeAllViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = NowPlayingState
    
    func newState(state: NowPlayingState) {
        if state.collectionState == .done {
            if let movies = state.movies {
                self.nowPlayingMovies = movies
            }
            if let posters = state.posters {
                self.posters = posters
            }
            self.showingLabel.text = "Showing \(self.nowPlayingMovies.count) results"
        }
    }
}
