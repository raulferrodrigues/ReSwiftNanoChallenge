//
//  Actions.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

struct GetPopular: Action { }

struct GetNowPlaying: Action { }

struct SetPopular: Action {
    let movies: [Result]
}

struct SetNowPlaying: Action {
    let movies: [Result]
}

struct ErrorAction: Action {
    let error: Error
}
