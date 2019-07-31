//
//  ModeratorSearchVC.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import UIKit

class ModeratorSearchVC: UIViewController {

    private enum SegueIdentifiers {
        static let list = "ListViewController"
    }
    @IBOutlet weak var siteTxtFld: UITextField!
    @IBOutlet weak var searchBtn: UIButton!

    private var behavior: ButtonEnablingBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Search", comment: "")

        behavior = ButtonEnablingBehavior(textFields: [siteTxtFld]) { [unowned self] enable in
            if enable {
                self.searchBtn.isEnabled = true
                self.searchBtn.alpha = 1
            } else {
                self.searchBtn.isEnabled = false
                self.searchBtn.alpha = 0.7
            }
        }
        siteTxtFld.setBottomBorder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.list {
            if let listVC = segue.destination as? ModeratorListVC {
                listVC.site = siteTxtFld.text!
            }
        }
    }


}
