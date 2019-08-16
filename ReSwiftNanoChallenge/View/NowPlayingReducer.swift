//
//  NowPlayingReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func nowPlayingReducer(action: Action, state: NowPlayingState?) -> NowPlayingState {
    let state = state ?? NowPlayingState(collection: .loading)
    return state
}
