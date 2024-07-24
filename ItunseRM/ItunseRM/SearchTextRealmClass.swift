//
//  SearchTextRealmClass.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 23.07.2024.
//

import Foundation
import RealmSwift

class SearchHistoryRealm: Object {
    @objc dynamic var personIDRealm = Int()
    var searchTexts = List<String>()

    override static func primaryKey() -> String? {
        return "personIDRealm"
    }
}
