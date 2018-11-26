//
//  AlbomDetailTableViewController.swift
//  Fora
//
//  Created by Александр Сахнюков on 20/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet var dataProvider: DataProviderDetailView!
    
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistLable: UILabel!
    @IBOutlet weak var albumLable: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLables(album: dataProvider.dataManager.albumDetail!)
        setLoadingScreen()
        fetchTracks()
        setAlbumImage()
    }
    
    // MARK: - Fetch
    
    private  func fetchTracks() {
        networkManager.fetchAlbumTracks(albumID:String(dataProvider.dataManager.albumDetail!.collectionId!)) { [weak self]  tracks in
           guard let self = self else { return }
            self.dataProvider.dataManager.albumTracks = tracks.results
            self.dataProvider.dataManager.albumTracks.removeFirst()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    // MARK: - UI
    
    private   func setAlbumImage() {
        dataProvider.dataManager.cacheImage.downloadImage(url: dataProvider.dataManager.albumDetail!.artworkUrl100!)  { [weak self]  image in
            guard let self = self else { return }
            self.albumImage.image = image
        }
    }
    
    private  func  setLables (album:Album) {
        artistLable.text = album.artistName
        albumLable.text = album.collectionName
        countryLable.text = album.country
        dateLable.text = album.releaseDate
    }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    private func setLoadingScreen() {
        self.tableView.separatorColor = .white
        loadingView.frame = CGRect(x: tableView.frame.width / 2, y: tableView.frame.height / 2, width: tableView.frame.width, height: tableView.frame.height)
        spinner.style = .gray
        spinner.startAnimating()
        loadingView.addSubview(spinner)
        tableView.addSubview(loadingView)
    }
}
