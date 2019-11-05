//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Blake Andrew Price on 11/4/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    let searchResultsController = SearchResultController()
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let result = searchResultsController.searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.creator
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }
    
    //MARK: - Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var resultType: ResultType!
        if let searchBarText = searchBar.text {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                resultType = .software
            case 1:
                resultType = .musicTrack
            case 2:
                resultType = .movie
            default:
                return
            }
            searchResultsController.performSearch(searchTerm: searchBarText, resultType: resultType) { (error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
