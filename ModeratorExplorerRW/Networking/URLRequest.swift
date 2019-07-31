//
//  URLRequest.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

extension URLRequest {
    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }

        var encoudedURLRequest = self

        if let url = self.url,
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
        var newUrlComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newUrlComponents.queryItems = queryItems
            encoudedURLRequest.url = newUrlComponents.url
            return encoudedURLRequest
        } else {
            return self
        }
    }
}
