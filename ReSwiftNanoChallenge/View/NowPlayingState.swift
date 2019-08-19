//
//  NowPlayingState.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

struct NowPlayingState: StateType {
    var collectionState: DataState
    var movies: [Result]?
    var error: Error?
}

enum DataState {
    case loading
    case done
    case error
}
