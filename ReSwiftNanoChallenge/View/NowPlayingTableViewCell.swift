//
//  NowPlayingTableViewCell.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit
import ReSwift

class NowPlayingTableViewCell: UITableViewCell {

    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    var nowPlayingMovies: [Result]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        
        if let action = fetchNowPlaying(state: store.state.nowPlayingState, store: store) {
            store.dispatch(action)
        }
        
        store.subscribe(self) {
            $0.select{
                $0.nowPlayingState
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NowPlayingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = nowPlayingMovies?.count {
            if numberOfItems > 5 {
                return 5
            } else {
                return numberOfItems
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! NowPlayingCollectionViewCell
        
        if let nowPlayingMovies = nowPlayingMovies {
            let imagePath = nowPlayingMovies[indexPath.row].posterPath ?? "placeholder-image"
            let title = nowPlayingMovies[indexPath.row].title ?? "'"
            let rate = nowPlayingMovies[indexPath.row].voteAverage ?? 0
            let dic = store.state.nowPlayingState.posters ?? [:]
            cell.set(image: dic[imagePath]!!, title: title, rate: String(rate))
        }
        
        return cell
    }
}

extension NowPlayingTableViewCell: StoreSubscriber {
    typealias StoreSubscriberStateType = NowPlayingState
    
    func newState(state: NowPlayingState) {
        switch state.collectionState {
        case .loading,
            .error:
            DispatchQueue.main.async {
                self.nowPlayingCollectionView.isHidden = false
            }
        case .done:
            DispatchQueue.main.async {
                self.nowPlayingMovies = state.movies
                self.nowPlayingCollectionView.reloadData()
                self.nowPlayingCollectionView.isHidden = false
            }
        }
    }
}

extension NowPlayingTableViewCell {
    func fetchNowPlaying(state: NowPlayingState, store: Store<AppState>) -> Action? {
        if state.collectionState == .loading {
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                Network.nowPlaying { (results, error) in
                    if let error = error {
                        store.dispatch(ErrorAction(error: error))
                    } else {
                        guard let results = results else { return }
                        var dic: [String: Data?] = [:]
                        for result in results {
                            guard let posterPath = result.posterPath else { return }
                            Network.moviePoster(imagePath: posterPath) { (data, path) in
                                guard let path = path else { return }
                                dic.updateValue(data, forKey: path)
                            }
                        }
                        store.dispatch(SetNowPlaying(movies: results, posters: dic))
                    }
                }
            }
        }
        return nil
    }
}
