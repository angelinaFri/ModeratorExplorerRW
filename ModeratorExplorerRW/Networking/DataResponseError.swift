//
//  DataResponseError.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding

    var reason: String {
        switch self {
        case .network:
            return "An error occured while fetching data ".localizedString
        case .decoding:
            return "An error occured while decoding data ".localizedString
        }
    }
}
