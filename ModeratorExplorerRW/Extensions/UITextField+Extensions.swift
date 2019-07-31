//
//  UITextField+Extensions.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.masksToBounds = false
        layer.shadowColor = ColorPalette.RWGreen.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}
