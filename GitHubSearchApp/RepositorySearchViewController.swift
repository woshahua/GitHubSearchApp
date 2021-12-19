//
//  RepositorySearchViewController.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/14.
//

import UIKit

final class RepositorySearchViewController: UIViewController {
    @IBOutlet private weak var searchResultTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var lastContentOffset: CGFloat = 0
    private var currentPage = 1
    private var currentSearchText = ""
    private let pageLimit = 10
    private var repositoryData: [RepositoryData] = []
    
    private let httpClient = HTTPClient()
    private let debounceAction = DispatchQueue.global().debounce(delay: .milliseconds(500))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureTableView()
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    private func configureTableView() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    private func fetch(name: String) {
        debounceAction { [unowned self] in
            let req = GitHubRepoGetAPI(queryName: name, page: currentPage, perPage: 10)
            self.httpClient.send(req) { [weak self] (res: Result<RepositoryDataList, APIError>) in
                switch res {
                case let .success(data):
                    _ = data.items.map {
                        self?.repositoryData.append($0)
                    }
                    DispatchQueue.main.async {
                        self?.searchResultTableView.reloadData()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.searchResultTableView.reloadData()
                        self?.showAlertDialog()
                    }
                }
            }
        }
    }
    
    private func showAlertDialog() {
        let alert = UIAlertController(title: "search error",
                                      message: "something wrong when try to search repositories",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        repositoryData = []
        currentPage = 1
        
        if searchText == "" {
            searchResultTableView.reloadData()
            return
        }
        
        currentSearchText = searchText
        fetch(name: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        repositoryData = []
        currentPage = 1
        fetch(name: currentSearchText)
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if scrollView.isReachedBottom, lastContentOffset < scrollView.contentOffset.y, currentPage < pageLimit {
            currentPage = currentPage + 1
            fetch(name: currentSearchText)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = repositoryData[indexPath.row].fullName
        return cell
    }
}

extension UIScrollView {
    var isReachedBottom: Bool {
        return (contentOffset.y + frame.size.height) >= contentSize.height
    }
}
