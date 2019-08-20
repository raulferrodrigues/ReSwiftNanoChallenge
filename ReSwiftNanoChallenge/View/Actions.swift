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

struct GetDetails: Action { }

struct SetPopular: Action {
    let movies: [Result]
    let posters: [String: Data?]
}

struct SetNowPlaying: Action {
    let movies: [Result]
    let posters: [String: Data?]
}

struct SetDetails: Action {
    let id: Int
    let details: Details
}

struct ErrorAction: Action {
    let error: Error
}
