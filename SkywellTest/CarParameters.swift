//
//  CarParamerers.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import Foundation

enum CarTransmission: String {
    case automatic = "automatic",
    manual = "manual"
    
    static let allValues = [automatic, manual]
}

enum CarEngine: String {
    case two = "2.0i.e"
    
    static let allValues = [two]
}

enum CarCondition: String {
    case excellent = "excellent",
    good = "good",
    bad = "bad"
    
    static let allValues = [excellent, good, bad]
}
