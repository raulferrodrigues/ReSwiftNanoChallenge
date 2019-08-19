//
//  NowPlayingReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func nowPlayingReducer(action: Action, state: NowPlayingState?) -> NowPlayingState {
    var state = state ?? NowPlayingState(collectionState: .loading, movies: nil, posters: nil, error: nil)
    
    switch action {
    case _ as GetNowPlaying:
        break
    case let action as SetNowPlaying:
        state.movies = action.movies
        state.posters = action.posters
        state.collectionState = .done
    case let action as ErrorAction:
        state.collectionState = .error
        state.error = action.error
    default:
        break
    }
    
    return state
}
