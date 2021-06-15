//
//  SearchCollectionViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchTableViewController: UITableViewController, UISearchBarDelegate{
    
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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for styles
        tableView.backgroundColor = .white
        
        // for list
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        fetchRemote()
        
        // for searcher
        navigationItem.searchController = searchController
        
    }
    
    var response: Any?
    
    func updateUIView (){
        print("TODO: UPDATE UI VIEW", response)
    }
    
    func fetchRemote (){
        ArticleSearchRequest().send { result in
            switch result {
            case .success(let res):
                self.response = res
            case .failure:
                self.response = nil
            }
            DispatchQueue.main.async {
                self.updateUIView()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }


}
