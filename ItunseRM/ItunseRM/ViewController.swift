//
//  ViewController.swift
//  ItunseRM
//
//  Created by Рахим Габибли on 21.07.2024.
//

import UIKit
import SnapKit
import RealmSwift

final class ViewController: UIViewController {

    var searchBar = UISearchBar()
    var collectionView: UICollectionView!
    let networkManager = NetworkManager()
    let realmManager = RealmManager()
    let searchHistoryViewController = SearchHistoryViewController()

    var albums = [Album]()

    var albums2: [Album] {
        return self.realmManager.getAlbums()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        print(albums.count)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowlayout()
        )
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }

    private func collectionViewFlowlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 380, height: 80)

        return layout
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        let album = albums2[indexPath.item]
        guard let imageUrl = URL(string: album.artworkUrl100) else { return cell }

        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }

            DispatchQueue.main.async {
                guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }

                cell.albumLabel.text = album.collectionName
                cell.singerLabel.text = album.artistName
                cell.albumImage.image = UIImage(data: imageData)
                cell.trackCountLabel.text = "\(album.trackCount) tracks"
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailsViewController = AlbumDetailsViewController()
        let album = albums2[indexPath.item]
        albumDetailsViewController.album = album
        albumDetailsViewController.title = album.collectionName

        navigationController?.pushViewController(albumDetailsViewController, animated: false)
    }
}
