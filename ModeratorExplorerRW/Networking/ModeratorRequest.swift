//
//  ModeratorRequest.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

struct ModeratorRequest {
    var path: String {
        return "users/moderators"
    }

    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ModeratorRequest {
    static func from(site: String) -> ModeratorRequest {
        let defaultsParameters = ["order": "desc", "sort": "reputation", "filter": "!-*jbN0CeyJHb"]
        let parameters = ["site": "\(site)"].merging(defaultsParameters, uniquingKeysWith: +)
        return ModeratorRequest(parameters: parameters)
    }
}
