//
//  Localization.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

var LS: ((_ key: String) -> String) = { key in
    return NSLocalizedString(key, tableName: nil, comment: "")
}
