//
//  AppReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        nowPlayingState: nowPlayingReducer(action: action, state: state?.nowPlayingState),
        popularState: popularReducer(action: action, state: state?.popularState),
        detailsState: detailsReducer(action: action, state: state?.detailsState)
    )
}
