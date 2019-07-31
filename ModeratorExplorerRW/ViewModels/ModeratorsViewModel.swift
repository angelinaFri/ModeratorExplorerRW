//
//  ModeratorsViewModel.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

protocol ModeratorsViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {
    private weak var delegate: ModeratorsViewModelDelegate?

    private var moderators: [Moderator] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false

    let client = StackExchangeClient()
    let request: ModeratorRequest

    init(request: ModeratorRequest, delegate: ModeratorsViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }

    var totalCount: Int {
        return total
    }

    var currentCount: Int {
        return moderators.count
    }

    func moderator(at index: Int) -> Moderator {
        return moderators[index]
    }

    func fetchModerators() {
        // 1
        /* Bail out, if a fetch request is already in progress. This prevents multiple requests happening. More on that later */
        guard !isFetchInProgress else { return }

        // 2
        /* If a fetch request is not in progress, set isFetchInProgress to true and send the request */
        isFetchInProgress = true

        client.fetchModerators(with: request, page: currentPage) { result in
            switch result {
        // 3
        /* If the request fails, inform the delegate of the reason for that failure and show the user a specific alert. */
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
        // 4
        /* If it’s successful, append the new items to the moderators list and inform the delegate that there’s data available
                 Note: In both the success and failure cases, you need to tell the delegate to perform its work on the main thread: DispatchQueue.main. This is necessary since the request happens on a background thread and you’re going to manipulate UI elements.*/
            case .success(let response):
//                DispatchQueue.main.async {
//                    self.isFetchInProgress = false
//                    self.moderators.append(contentsOf: response.moderators)
//                    self.delegate?.onFetchCompleted(with: .none)
//                }
                DispatchQueue.main.async {
            // 1.1
            /* If the response is successful, increment the page number to retrieve. Remember that the API request pagination is defaulted to 30 items. Fetch the first page, and you'll retrieve the first 30 items. With the second request, you'll retrieve the next 30, and so on. The retrieval mechanism will continue until you receive the full list of moderators. */
                self.currentPage += 1
                self.isFetchInProgress = false
            // 1.2
            /* Store the total count of moderators available on the server. You'll use this information later to determine whether you need to request new pages. Also store the newly returned moderators. */
                self.total = response.total
                self.moderators.append(contentsOf: response.moderators)
            // 1.3
            /* If this isn't the first page, you'll need to determine how to update the table view content by calculating the index paths to reload. */
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsTOReload(from: response.moderators)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                    self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    /* This utility calculates the index paths for the last page of moderators received from the API. You'll use this to refresh only the content that's changed, instead of reloading the whole table view. */
    private func calculateIndexPathsTOReload(from newModerators: [Moderator]) -> [IndexPath] {
        let startIndex = moderators.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
    }
}

