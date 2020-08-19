//
//  NSString+Ranges.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

extension NSString {
    func ranges(of substring: String, options: NSString.CompareOptions) -> [NSRange] {
        var searchRange = NSRange(location: 0, length: self.length)
        var foundRange = NSRange()
        var ranges: [NSRange] = [NSRange]()
        while searchRange.location < self.length {
            searchRange.length = self.length - searchRange.location
            foundRange = self.range(of: substring, options: options, range: searchRange)
            if foundRange.location != NSNotFound {
                // found an occurrence of the substring! do stuff here
                searchRange.location = foundRange.location + foundRange.length
                ranges.append(foundRange)
            }
            else {
                // no more substring to find
                break
            }
        }
        return ranges
    }
}
