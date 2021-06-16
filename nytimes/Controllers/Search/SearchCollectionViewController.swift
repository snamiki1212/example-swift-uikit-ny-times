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
    
    private var fetchedList = [ArticleResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for styles
        tableView.backgroundColor = .white
        
        // for list
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
//        search()
        
        // for searcher
        navigationItem.searchController = searchController
        tableView.refreshControl = UIRefreshControl()
    }
    
    var response: Response? // TODO: removeResponse
    
    func updateUIView (){
        print("TODO: UPDATE UI VIEW", response)
    }
    
//    func diffWithSearchedResponses(_ list: [Response]) -> [Response] {
//        if fetchedList.count == 0 {
//            return list
//        }
//        return fetchedList.difference(from: list)
////        return fetchedList.count == 0 ? list : fetchedList.difference(from: list)
//    }
    
    func search (){
        print("START search")
        guard let searchText = self.searchText else {
            refreshControl?.endRefreshing()
            return
        }
        // TODO: fetch with searchText
        print(searchText)
        ArticleSearchRequest().send { result in
            switch result {
            case .success(let res):
                self.response = res
            case .failure:
                self.response = nil
            }
            DispatchQueue.main.async {
                self.updateUIView()
//                self.fetchedList.append(contentsOf: [self.response!])
                self.fetchedList = self.response?.response.docs ?? []
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }


}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchText = searchText
        }
    }
}
