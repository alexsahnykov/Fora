//
//  File.swift
//  Fora
//
//  Created by Александр Сахнюков on 26/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit


class DataProviderSearchView: NSObject {
    var dataManager = DataManagerSearchView()
}

extension DataProviderSearchView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.searchingAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCollectionViewCell
        cell.updateCell(album: dataManager.searchingAlbums[indexPath.row])
        cell.fileImage.image = nil
        dataManager.cacheImage.downloadImage(url: dataManager.searchingAlbums[indexPath.row].artworkUrl100!)  { image in
            cell.image  = image
        }
        return cell
    }
}

extension DataProviderSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumForSegue = dataManager.searchingAlbums[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutVc = storyboard.instantiateViewController(withIdentifier: "albumInfo") as! AlbumDetailTableViewController
        aboutVc.dataProvider.dataManager.albumDetail = albumForSegue
        aboutVc.dataProvider.dataManager.cacheImage = dataManager.cacheImage
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelagate.window?.rootViewController as! UINavigationController
        navigationController.pushViewController(aboutVc, animated: true)
    }
    
}

