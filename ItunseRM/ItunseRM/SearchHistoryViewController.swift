//
//  SearchHistoryViewController.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 21.07.2024.
//

import UIKit

class SearchHistoryViewController: UIViewController {

    let identifire = "searchCell"
    let searchHistoryRealm = SearchRealmManager.shared
    var searchHistory = [String]()

    var tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            self.searchHistory = self.searchHistoryRealm.getSearchTexts()
            self.tableView.reloadData()
        }
    }

    private func setup() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        tableView.dataSource = self
        tableView.delegate = self
        title = "Search history"

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension SearchHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row]
        return cell
    }
}

extension SearchHistoryViewController: UITableViewDelegate {}
