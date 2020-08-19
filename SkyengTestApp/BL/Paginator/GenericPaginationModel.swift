//
//  GenericPaginationModel.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation
struct PaginationModel<T> {

    // MARK: - Properties

    var dataSource: [T] = []

    var isLoading: Bool = false

    var offset: Int {
        return dataSource.count
    }

    var canLoadMoreData: Bool {
        return !isLoading && !lastPage
    }
    
    var lastPage: Bool = false

    // MARK: - Public

     mutating func clear() {
        dataSource.removeAll()
        lastPage = false
    }
}
