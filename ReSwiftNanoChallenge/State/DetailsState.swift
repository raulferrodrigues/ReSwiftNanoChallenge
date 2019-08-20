//
//  DetailsState.swift
//  ReSwiftNanoChallenge
//
//  Created by Raul Rodrigues on 8/19/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

struct DetailsState: StateType {
    var dataState: DataState
    var id: Int?
    var details: Details?
    var error: Error?
}
