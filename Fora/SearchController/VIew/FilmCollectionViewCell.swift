//
//  FilmCollectionViewCell.swift
//  Fora
//
//  Created by Александр Сахнюков on 20/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    var image: UIImage? {
        didSet{
            fileImage.image = image
            activityView.stopAnimating()
            activityView.isHidden = true
        }
    }
    
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var albumTitleLable: UILabel!
    @IBOutlet weak var albumArtistLable: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    func updateCell (album: Album) {
        albumTitleLable.text = album.collectionName
        albumArtistLable.text = album.artistName
        activityView.startAnimating()
        activityView.isHidden = false
    }
}


