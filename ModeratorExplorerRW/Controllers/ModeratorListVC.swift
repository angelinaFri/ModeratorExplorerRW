//
//  ModeratorListVC.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import UIKit

class ModeratorListVC: UIViewController, AlertDisplayer {
    private enum CellIdentifiers {
        static let list = "List"
    }


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var site: String!
    private var viewModel: ModeratorsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.color = ColorPalette.RWGreen
        activityIndicator.startAnimating()

        tableView.isHidden = true
        tableView.separatorColor = ColorPalette.RWGreen
        tableView.dataSource = self
        tableView.prefetchDataSource = self

        let request = ModeratorRequest.from(site: site)
        viewModel = ModeratorsViewModel(request: request, delegate: self)

        viewModel.fetchModerators()
    }
}

extension ModeratorListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return viewModel.currentCount
        // 1
        /* Instead of returning the count of the moderators you've received already, you return the total count of moderators available on the server so that the table view can show a row for all the expected moderators, even if the list is not complete yet. */
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! ModeratorTableViewCell
        // 2
        /* If you haven't received the moderator for the current cell, you configure the cell with an empty value. In this case, the cell will show a spinning indicator view. If the moderator is already on the list, you pass it to the cell, which shows the name and reputation. */
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
           cell.configure(with: viewModel.moderator(at: indexPath.row))
        }
        return cell
    }
}

extension ModeratorListVC: ModeratorsViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        /* If newIndexPathsToReload is nil (first page), hide the indicator view, make the table view visible and reload it. */
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        /* If newIndexPathsToReload is not nil (next pages), find the visible cells that needs reloading and tell the table view to reload only those. */
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func onFetchFailed(with reason: String) {
        activityIndicator.stopAnimating()

        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title, message: reason, actions: [action])
    }
}

extension ModeratorListVC: UITableViewDataSourcePrefetching {
    /* As soon as the table view starts to prefetch a list of index paths, it checks if any of those are not loaded yet in the moderators list. If so, it means you have to ask the view model to request a new page of moderatos. Since tableView(_:prefetchRowsAt:) can be called multiple times, the view model — thanks to its isFetchInProgress property — knows how to deal with it and ignores subsequent requests until it's finished. */
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchModerators()
        }
    }
}

// MARK: - Utility methods before UITableViewDataSourcePrefetching logic

private extension ModeratorListVC {
    /* Allows you to determine whether the cell at that index path is beyond the count of the moderators you have received so far. */
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    /* This method calculates the cells of the table view that you need to reload when you receive a new page. It calculates the intersection of the IndexPaths passed in (previously calculated by the view model) with the visible ones. You'll use this to avoid refreshing cells that are not currently visible on the screen. */
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
