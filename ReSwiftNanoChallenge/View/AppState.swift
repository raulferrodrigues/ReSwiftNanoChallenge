//
//  AppState.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 15/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let nowPlayingState: NowPlayingState
    let popularState: PopularState
    let detailsState: DetailsState
}
