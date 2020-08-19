//
//  XCTest+.swift
//  SkyengTestAppTests
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

func correctFile(_ file: String) -> String {
    var url = URL(fileURLWithPath: file)
    url.deletePathExtension()
    return url.lastPathComponent
}

func wrongFile(_ file: String) -> String {
    var url = URL(fileURLWithPath: file)
    url.deletePathExtension()
    return "Wrong" + url.lastPathComponent
}

func wrongDecodeFile(_ file: String) -> String {
    var url = URL(fileURLWithPath: file)
    url.deletePathExtension()
    return "WrongDecode" + url.lastPathComponent
}
