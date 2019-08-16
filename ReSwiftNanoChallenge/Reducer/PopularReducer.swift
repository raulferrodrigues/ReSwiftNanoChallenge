//
//  PopularReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func popularReducer(action: Action, state: PopularState?) -> PopularState {
    let state = state ?? PopularState(table: .loading)
    return state
}
