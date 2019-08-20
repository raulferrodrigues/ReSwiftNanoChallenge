//
//  PopularReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func popularReducer(action: Action, state: PopularState?) -> PopularState {
    var state = state ?? PopularState(tableState: .loading, movies: nil, posters: nil ,error: nil)
    
    switch action {
    case _ as GetPopular:
        state.tableState = .loading
        state.error = nil
    case let action as SetPopular:
        state.movies = action.movies
        state.posters = action.posters
        state.tableState = .done
    case let action as ErrorAction:
        state.tableState = .error
        state.error = action.error
    default:
        break
    }
    
    return state
}
