//
//  FilmCollectionViewCell.swift
//  Fora
//
//  Created by Александр Сахнюков on 20/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var albumTitleLable: UILabel!
    @IBOutlet weak var albumArtistLable: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    func updateCell (album: Album) {
        albumTitleLable.text = album.collectionName
        albumArtistLable.text = album.artistName
        fileImage.image = nil
        activityView.startAnimating()
        self.activityView.isHidden = false
        guard let url = album.artworkUrl100 else {return}
        networkManager.fetchImage(url: url) { (image) in
            DispatchQueue.main.async {
                self.fileImage.image = image
                self.activityView.stopAnimating()
                self.activityView.isHidden = true
            }
            
        }
    }
}

