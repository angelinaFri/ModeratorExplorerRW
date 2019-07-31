//
//  PagedModeratorResponse.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

struct PagedModeratorResponse: Decodable {
    let moderators: [Moderator]
    let total: Int
    let hasMore: Bool
    let page: Int

    enum CodingKeys: String, CodingKey {
        case moderators = "items"
        case hasMore = "has_more"
        case total
        case page
    }
}
