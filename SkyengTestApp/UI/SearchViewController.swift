//
//  SearchViewController.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    private var words: PaginationModel<WordResponse> = PaginationModel<WordResponse>()
    private let searchManager = SearchManager()
    private var searchString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        localize()
        addSearch()
    }

    //MARK: - Private
    
    private func localize() {
        self.title = LS("search.title")
    }

    private func addSearch() {
        let search = UISearchController (searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Enter word for search"
        self.navigationItem.searchController = search
    }
    
    private func loadWords() {
        guard let searchString = self.searchString else {
            return
        }
        words.isLoading = true
        searchManager.search(by: searchString, offset: words.offset, success: { (words) in
            self.words.dataSource += words
            self.words.lastPage = words.count < pageSize
            self.tableView.reloadData()
            self.words.isLoading = false
        }) { (error) in
            self.words.isLoading = false
        }
    }
    
    private func reloadData() {
        words.clear()
        loadWords()
    }
    
    private func prepareNewApproveDataIfNeeded(indexPath: IndexPath) {
        if
        indexPath.row == words.dataSource.count - 1,
            words.canLoadMoreData {
                loadWords()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        cell.applyModel(WordCellModel(text: words.dataSource[indexPath.row].text, searchString: self.searchString))
        self.prepareNewApproveDataIfNeeded(indexPath: indexPath)
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchString = searchController.searchBar.text
        if let searchString = self.searchString, !searchString.isEmpty {
            self.reloadData()
        }
        else {
            words.clear()
            self.tableView.reloadData()
        }
    }
}
