//
//  RealmManager.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 23.07.2024.
//

import Foundation
import RealmSwift

class RealmManager {

    static let shared = RealmManager()
    private let realm = try! Realm()

    var searchTexts = [String]()

    private func convertToRealmAlbum(_ album: Album) -> RealmClass {
        let albumRealm = RealmClass()
        albumRealm.personIDRealm = album.artistId
        albumRealm.singerLabelRealm = album.artistName
        albumRealm.albumLabelRealm = album.collectionName
        albumRealm.albumImageURLRealm = album.artworkUrl100
        albumRealm.trackCountLabelRealm = album.trackCount
        return albumRealm
    }

    func saveAlbums(_ albums: [Album]) {
        do {
            try realm.write {
                let oldAlbums = realm.objects(RealmClass.self)
                realm.delete(oldAlbums)

                let realmAlbums = albums.map { convertToRealmAlbum($0) }
                realm.add(realmAlbums, update: .all)
            }
        } catch {
            print("Error saving albums: \(error.localizedDescription)")
        }
    }

    func getAlbums() -> [Album] {
        let results = realm.objects(RealmClass.self)
        var albums = [Album]()
        for result in results {
            let album = Album(
                artistId: result.personIDRealm,
                artistName: result.singerLabelRealm,
                collectionName: result.albumLabelRealm,
                artworkUrl100: result.albumImageURLRealm,
                trackCount: result.trackCountLabelRealm
            )
            albums.append(album)
        }
        return albums
    }

    func saveSearchTextToRealm(_ searchText: String) {

    }

}
