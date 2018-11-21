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
        activityView.startAnimating()
        fileImage.image = nil
        guard let url = album.artworkUrl100 else {return}
        let imageUrl = URL(string: url)
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl!) {
                DispatchQueue.main.async {
                    self.fileImage.image = UIImage(data: imageData)
                    self.activityView.stopAnimating()
                    self.activityView.isHidden = true
                }
            }
        }
    }
}
