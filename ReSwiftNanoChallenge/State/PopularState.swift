//
//  PopularState.swift
//  ReSwiftNanoChallenge
//
//  Created by Arthur Bastos Fanck on 16/08/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

struct PopularState: StateType {
    var tableState: DataState
    var movies: [Result]?
    var posters: [String: Data?]?
    var error: Error?
}
