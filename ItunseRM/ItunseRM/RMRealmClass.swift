//
//  RMRealmClass.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 21.07.2024.
//

import Foundation
import RealmSwift

class RMRealmClass: Object {
    @objc dynamic var personIDRealm = String()
    @objc dynamic var albumImageURLRealm = String()
    @objc dynamic var albumLabelRealm = String()
    @objc dynamic var singerLabelRealm = String()
    @objc dynamic var trackCountLabelRealm = String()

    override static func primaryKey() -> String? {
        return "personIDRealm"
    }
}
