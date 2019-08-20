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
    let searchController = UISearchController(searchResultsController: nil)
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    var errorView: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Delegates
        mainTable.delegate = self
        mainTable.dataSource = self
        
        // MARK: - Spinner Indicator
        self.spinner.color = .gray
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.spinner)
        self.spinner.centerXAnchor.constraint(equalTo: self.mainTable.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: self.mainTable.centerYAnchor).isActive = true
        
        // MARK: - Search Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? Result                                else { fatalError() }
        guard let destination = segue.destination as? DetailsViewController else { fatalError() }
        guard let dictionary = store.state.popularState.posters             else { fatalError() }
        guard let posterPath = sender.posterPath                            else { fatalError() }
        guard let value = dictionary[posterPath]                            else { fatalError() }
        guard let posterData = value                                        else { fatalError() }
        guard let image = UIImage(data: posterData)                         else { fatalError() }

        destination.movie = sender
        destination.poster = image
    }
}

// MARK: - Table View Delegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 21))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 14, y: 0, width: view.frame.width/2, height: view.frame.height))
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        view.addSubview(label)
        if section == 0 {
            label.text = "Now Playing"
            
            let width = view.frame.size.width/4
            
            let button = UIButton(frame: CGRect(x: view.frame.size.width - width - 10, y: 3, width: view.frame.width/4, height: view.frame.height))
            button.backgroundColor = .clear
            button.setTitle("See All", for: .normal)
            button.setTitleColor(UIColor(named: "VeryDarkGray"), for: .normal)
            button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14)
            view.addSubview(button)
            button.addTarget(self, action: #selector(seeAllTapped), for: .touchDown)
        } else {
            label.text = "Popular Movies"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 65))
        view.backgroundColor = .white
        let line = UIView(frame: CGRect(x: 15, y: view.frame.height/2, width: (view.frame.width-30), height: 0.5))
        line.backgroundColor = .lightGray
        view.addSubview(line)
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
                let dic = store.state.popularState.posters ?? [:]
                cell.set(image: dic[posterPath]!!, title: title, overview: overview, rate: String(rate))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let popularMovies = popularMovies else { return }
        performSegue(withIdentifier: "detailsSegue", sender: popularMovies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if indexPath.section == 0 {
            height = 300
        } else {
            height = 139
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 65
        } else {
            return 0
        }
    }
}

// MARK: - Store Subscriber
extension MainViewController: StoreSubscriber {
    func newState(state: (state1: NowPlayingState, state2: PopularState)) {
        let nowPlayingCollection =  state.state1.collectionState
        let popularTable = state.state2.tableState
        
        switch (nowPlayingCollection, popularTable) {
        case (.done, .done):
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.popularMovies = state.state2.movies
                self.mainTable.reloadData()
                self.mainTable.isHidden = false
            }
        case (_, .error),
             (.error, _):
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.mainTable.isHidden = true
                self.errorView = ErrorView(frame: self.view.frame)
                self.view.addSubview(self.errorView!)
                self.errorView?.tryAgainButton.addTarget(self, action: #selector(self.tryAgainTapped), for: .touchDown)
            }
        case (.done, .loading):
            _ = self.fetchPopular(state: state.state2, store: store)
            DispatchQueue.main.async {
                self.spinner.startAnimating()
                self.mainTable.isHidden = true
                self.errorView?.isHidden = true
            }
        default:
            DispatchQueue.main.async {
                self.spinner.startAnimating()
                self.mainTable.isHidden = true
                self.errorView?.isHidden = true
            }
        }
    }
}

// MARK: - Outros
extension MainViewController {
    func fetchPopular(state: PopularState, store: Store<AppState>) -> Action? {
        if state.tableState == .loading {
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                Network.popular { (results, error) in
                    if let error = error {
                        store.dispatch(ErrorAction(error: error))
                    } else {
                        guard var results = results else { return }
                        guard let nowPlayingResults = store.state.nowPlayingState.movies else { return }
                        
                        // REMOVE MOVIES THAT ARE NOW PLAYING FROM POPULAR MOVIES
                        for index in 0 ... 4 {
                            let movie = nowPlayingResults[index]
                            results = results.filter{
                                $0.id != movie.id
                            }
                        }
                        
                        // SORT POPULAR MOVIES BY AVERAGE VOTE
                        results.sort(by: { (movieA, movieB) -> Bool in
                            movieA.voteAverage! > movieB.voteAverage!
                        })
                        
                        var dic: [String : Data?] = [:]
                        for result in results {
                            guard let posterPath = result.posterPath else { return }
                            Network.moviePoster(imagePath: posterPath) { (data, path) in
                                guard let path = path else { return }
                                dic.updateValue(data, forKey: path)
                            }
                        }
                        store.dispatch(SetPopular(movies: results, posters: dic))
                    }
                }
                
                
            }
        }
        return nil
    }
    
    @objc func tryAgainTapped() {
        print("TRY AGAIN CLICADO")
        store.dispatch(GetPopular())
        store.dispatch(GetNowPlaying())
    }
    
    @objc func seeAllTapped() {
        print("SEE ALL CLICADO")
        
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // MARK: - TO DO
    }
}
