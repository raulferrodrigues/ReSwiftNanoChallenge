//
//  PopularReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func popularReducer(action: Action, state: PopularState?) -> PopularState {
    var state = state ?? PopularState(tableState: .loading, movies: nil, error: nil)
    
    switch action {
    case _ as GetPopular:
        break
    case let action as SetPopular:
        state.movies = action.movies
        state.tableState = .done
    case let action as ErrorAction:
        state.tableState = .error
        state.error = action.error
    default:
        break
    }
    
    return state
}
