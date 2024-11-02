//
//  NetworkManager.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 21.07.2024.
//
// swiftlint:disable force_cast
// swiftlint:disable force_try

import Foundation
import RealmSwift

struct AlbumName: Codable {
    let results: [Album]
}

struct Album: Codable {
    let artistId: Int
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let trackCount: Int
}

class NetworkManager {
    static let shared = NetworkManager()
    let realmManager = RealmManager()

    func fetchAlbum(albumName: String) -> String {
        let url = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        return url
    }

    func getAlbums(albumName: String, completionHandler: @escaping ([Album]) -> Void) {
        let urlString = fetchAlbum(albumName: albumName)
        guard let url = URL(string: urlString) else {
            print("Error")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("No data")
                return
            }

            do {
                let albums = try JSONDecoder().decode(AlbumName.self, from: data).results

                DispatchQueue.main.async {
                    let realm = try! Realm()

                    try! realm.write {
                        let oldAlbums = realm.objects(RealmClass.self)
                        realm.delete(oldAlbums)
                    }

                    for album in albums {
                        try! realm.write {
                            let rmRealm = RealmClass()
                            rmRealm.personIDRealm = album.artistId
                            rmRealm.albumImageURLRealm = album.artworkUrl100
                            rmRealm.albumLabelRealm = album.collectionName
                            rmRealm.singerLabelRealm = album.artistName
                            rmRealm.trackCountLabelRealm = album.trackCount
                            realm.add(rmRealm, update: .all)
                        }
                    }
                    completionHandler(albums)
                }
            } catch {
                print("Error - ", error.localizedDescription)
            }
        }.resume()
    }

    func saveToSearchText(_ searchText: String) {

    }
}
