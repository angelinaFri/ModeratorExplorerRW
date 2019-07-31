//
//  Double+Extensions.swift
//  ModeratorExplorerRW
//
//  Created by Angelina on 7/31/19.
//  Copyright © 2019 Angelina Friz. All rights reserved.
//

import Foundation

extension Double {
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    }()

    var formatted: String {
        return Double.formatter.string(for: self) ?? String(self)
    }
}
