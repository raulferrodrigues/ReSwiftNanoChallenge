//
//  MainViewController.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import UIKit
import ReSwift

class MainViewController: UIViewController {

    @IBOutlet weak var mainTable: UITableView!
    var popularMovies: [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        if let action = self.fetchPopular(state: store.state.popularState, store: store) {
            print("HEY THERE! FETCHPOPULAR NOT RETURNED NIL.")
            store.dispatch(action)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select{
                ($0.nowPlayingState, $0.popularState)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 21))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 14, y: 0, width: view.frame.width, height: view.frame.height))
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        view.addSubview(label)
        if section == 0 {
            label.text = "Now Playing"
        } else {
            label.text = "Popular Movies"
        }
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            guard let numberOfRows = popularMovies?.count else { return 0 }
            return numberOfRows
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularMoviesCell", for: indexPath) as! PopularTableViewCell
            if let popularMovies = popularMovies {
                let posterPath = popularMovies[indexPath.row].posterPath ?? "placeholder-image"
                let title = popularMovies[indexPath.row].title ?? ""
                let overview = popularMovies[indexPath.row].overview ?? ""
                let rate = popularMovies[indexPath.row].voteAverage ?? 0
                DispatchQueue.main.async { [weak cell, posterPath] in
                    guard let cell = cell else { return }
                    Network.moviePoster(imagePath: posterPath) { (data, path) in
                        if let data = data {
                            cell.set(image: data, title: title, overview: overview, rate: String(rate))
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if indexPath.section == 0 {
            height = 300
        } else {
            height = 119
        }
        return height
    }
}

extension MainViewController: StoreSubscriber {
    func newState(state: (state1: NowPlayingState, state2: PopularState)) {
        let nowPlayingCollection =  state.state1.collectionState
        let popularTable = state.state2.tableState
        
        switch (nowPlayingCollection, popularTable) {
        case (_, .done):
            DispatchQueue.main.async {
                self.popularMovies = state.state2.movies
                self.mainTable.reloadData()
                self.mainTable.isHidden = false
            }
            
        case (.error, .error):
            DispatchQueue.main.async {
                self.mainTable.isHidden = true
            }
            // SHOW MESSAGE OF ERROR
        default:
            DispatchQueue.main.async {
                self.mainTable.isHidden = true
            }
            // SHOW LOADING INDICATOR
        }
    }
}

extension MainViewController {
    func fetchPopular(state: PopularState, store: Store<AppState>) -> Action? {
        if state.tableState == .loading {
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                Network.popular { (results, error) in
                    if let error = error {
                        store.dispatch(ErrorAction(error: error))
                    } else {
                        store.dispatch(SetPopular(movies: results!))
                    }
                }
            }
        }
        return nil
    }
}
