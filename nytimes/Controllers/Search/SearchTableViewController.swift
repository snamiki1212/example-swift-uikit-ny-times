//
//  SearchCollectionViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

class SearchTableViewController: UITableViewController{
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        return sc
    }()
    
    var searchText: String? {
        didSet {
            navigationItem.searchController?.searchBar.text = searchText
            navigationItem.searchController?.searchBar.searchTextField.resignFirstResponder()
            tableView.reloadData()
            search()
        }
    }
    
    private var fetchedList = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for styles
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        
        // for table-view
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        
        // for searcher
        navigationItem.searchController = searchController
        tableView.refreshControl = UIRefreshControl()
    }
    
    func search (){
        guard let searchText = self.searchText else {
            refreshControl?.endRefreshing()
            return
        }
        
        SearchRequest().search(searchText: searchText) { result in
            self.fetchedList = {
                switch result {
                case .success(let res):
                    return res.response.docs
                case .failure:
                    return []
                }
            }()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as! SearchTableViewCell
        let item = fetchedList[indexPath.row]
        cell.item = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedList[indexPath.row]
        let vc = DetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchText = searchText
        }
    }
}
