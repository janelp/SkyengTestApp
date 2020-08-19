//
//  Logger.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

import UIKit
@_exported import SwiftyBeaver

let log = SwiftyBeaver.self

struct Logger {
    static func setup() {
        let console = ConsoleDestination()
        console.minLevel = .verbose
        log.addDestination(console)
    }
}
