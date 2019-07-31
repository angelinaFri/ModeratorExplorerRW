//
//  StackExchangeClient.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

final class StackExchangeClient {
    private lazy var baseUrl: URL = {
        return URL(string: "http://api.stackexchange.com/2.2/")!
    }()

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchModerators(with request: ModeratorRequest, page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
        // 1
        /* Build a request using URLRequest initializer. Prepend the base URL to the path required to get the moderators. After its resolution, the path will look like this: http://api.stackexchange.com/2.2/users/moderators. */
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent(request.path))
        // 2
        /* Create a query parameter for the desired page number and merge it with the default parameters defined in the ModeratorRequest instance — except for the page and the site; the former is calculated automatically each time you perform a request, and the latter is read from the UITextField in ModeratorsSearchViewController.*/
        let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        // 3
        /* Encode the URL with the parameters created in the previous step. Once done, the final URL for a request should look like this: http://api.stackexchange.com/2.2/users/moderators?site=stackoverflow&page=1&filter=!-*jbN0CeyJHb&sort=reputation&order=desc. Create a URLSessionDataTask with that request.*/
        let encodedURLRequest = urlRequest.encode(with: parameters)

        session.dataTask(with: encodedURLRequest, completionHandler: { (data, response, error) in
        // 4
        /*Validate the response returned by the URLSession data task. If it’s not valid, invoke the completion handler and return a network error result.*/
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
            else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
        // 5
        /*If the response is valid, decode the JSON into a PagedModeratorResponse object using the Swift Codable API. If it finds any errors, call the completion handler with a decoding error result.*/
            guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data)
            else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
        // 6
        /*Finally, if everything is OK, call the completion handler to inform the UI that new content is available.*/
            completion(Result.success(decodedResponse))

        }).resume()
    }
}
