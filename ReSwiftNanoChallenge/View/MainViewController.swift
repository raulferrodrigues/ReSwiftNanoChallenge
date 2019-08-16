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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTable.delegate = self
        mainTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        if section == 0 {
            title = "Now Playing"
        } else if section == 1 {
            title = "Popular Movies"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularMoviesCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        if indexPath.section == 0 {
            height = 300
        } else {
            height = 120
        }
        
        return height
    }
    
    
}

extension MainViewController: StoreSubscriber {
    func newState(state: AppState) {
        let nowPlayingState = state.nowPlayingState
        let popularState = state.popularState
        
        switch nowPlayingState.collection {
        case .loading :
            print()
        case .done:
            print()
        case .error:
            print()
        }
        
        switch popularState.table {
        case .loading :
            print()
        case .done:
            print()
        case .error:
            print()
        }
    }
}
