//
//  TabBarController.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 21.07.2024.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {

    var searchBar = UISearchBar()
    let networkManager = NetworkManager()
    let searchHistoryViewController = SearchHistoryViewController()
    let viewController = ViewController()
    let searchRealmManager = SearchRealmManager.shared
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewControllers()
        setupSearchBar()


//        if let searchTexts = networkManager.getSearchTextFromKeychain() {
//            performInitialSearch(with: searchTexts.last!)
//        }
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self

        if let navController = viewControllers?.first as? UINavigationController {
            navController.navigationBar.topItem?.titleView = searchBar
        }
    }

    private func setupViewControllers() {
        let searchNavController = UINavigationController(rootViewController: viewController)
        searchNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let historyNavController = UINavigationController(rootViewController: searchHistoryViewController)
        historyNavController.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 1)

        viewControllers = [searchNavController, historyNavController]
    }

    func performInitialSearch(with searchText: String) {
       searchBar.text = searchText
       searchBarSearchButtonClicked(searchBar)
   }
}


extension TabBarController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }


        DispatchQueue.main.async {
            self.searchRealmManager.addSearchText(searchText)
        }
//
////            self.searchHistoryViewController.searchHistory = self.searchRealmManager.getSearchTexts()
////            self.searchHistoryViewController.tableView.reloadData()
////            print(" weee \(self.searchHistoryViewController.searchHistory.count), \(self.searchRealmManager.getSearchTexts())")
//        }

        networkManager.getAlbums(albumName: searchText) { [weak self] albums in
                self?.albums = albums
            print(albums.count)
            DispatchQueue.main.async {
                self?.viewController.albums = albums
                self?.viewController.collectionView.reloadData()
                self?.searchHistoryViewController.tableView.reloadData()
            }
        }

//        searchBar.resignFirstResponder()
    }
}
