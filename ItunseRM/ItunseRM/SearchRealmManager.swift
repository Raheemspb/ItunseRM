//
//  SearchRealmManager.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 23.07.2024.
//
// swiftlint:disable force_cast
// swiftlint:disable force_try

import Foundation
import RealmSwift

class SearchRealmManager {

    static let shared = SearchRealmManager() // swiftlint:disable:next force_cast
    let realm = try! Realm()
    let searchHistory = SearchHistoryRealm()

    private func convertToRealmText(_ text: String) -> SearchHistoryRealm {
        searchHistory.searchTexts.append(text)
        return searchHistory
    }

    func addSearchText(_ searchText: String) {

        do {
            try realm.write {
                let searchTextsRealm = convertToRealmText(searchText)
                realm.add(searchTextsRealm, update: .all)
            }
        } catch {
            print("Sorry: ", error.localizedDescription)
        }
    }

    func getSearchTexts() -> [String] {
        if let searchHistory = realm.objects(SearchHistoryRealm.self).first {
            return Array(searchHistory.searchTexts)
        } else {
            return []
        }
    }
}
