//
//  DetailsReducer.swift
//  ReSwiftNanoChallenge
//
//  Created by Raul Rodrigues on 8/19/19.
//  Copyright © 2019 Raul Rodrigues. All rights reserved.
//

import ReSwift

func detailsReducer(action: Action, state: DetailsState?) -> DetailsState {
    var state = state ?? DetailsState(dataState: .loading, id: nil, details: nil, error: nil)
    
    switch action {
    case _ as GetDetails:
        break
    case let action as SetDetails:
        state.id = action.id
        state.details = action.details
        state.dataState = .done
    case let action as ErrorAction:
        state.dataState = .error
        state.error = action.error
    default:
        break
    }
    
    return state
}
