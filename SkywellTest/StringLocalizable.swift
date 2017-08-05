//
//  StringLocalizable.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/5/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
