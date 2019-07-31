//
//  ModeratorTableViewCell.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import UIKit

class ModeratorTableViewCell: UITableViewCell {

    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var reputationLbl: UILabel!
    @IBOutlet weak var reputationContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        reputationContainerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        reputationContainerView.layer.cornerRadius = 6
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = ColorPalette.RWGreen

    }

    func configure(with moderator: Moderator?) {
        if let moderator = moderator {
            displayNameLbl?.text = moderator.displayName
            reputationLbl?.text = moderator.reputation
            displayNameLbl.alpha = 1
            reputationContainerView.alpha = 1
            activityIndicator.stopAnimating()
        } else {
            displayNameLbl.alpha = 0
            reputationContainerView.alpha = 0
            activityIndicator.startAnimating()
        }
    }
}
