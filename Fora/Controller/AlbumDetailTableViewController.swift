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
    
    var albumTracks = [Track]()
    var albumDetail:Album!
    
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    @IBOutlet weak var albumImageActivityView: UIActivityIndicatorView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistLable: UILabel!
    @IBOutlet weak var albumLable: UILabel!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    
    // MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLables(album: albumDetail)
        setLoadingScreen()
        fetchTracks()
        setAlbumImage()
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumTracks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! TrackTableViewCell
        cell.updateCell(track: albumTracks[indexPath.row])
        return cell
    }
    
    // MARK: - Fetch
    
    private  func fetchTracks() {
        networkManager.fetchAlbumTracks(endpoint:.getAlbumTracks(albumId: String(albumDetail.collectionId!))) { tracks in
            self.albumTracks = tracks.results
            self.albumTracks.removeFirst()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    // MARK: - UI
    
    func setAlbumImage() {
        albumImageActivityView.isHidden = false
        albumImageActivityView.startAnimating()
        networkManager.downloadImage(url: albumDetail.artworkUrl100!) { (image) in
            DispatchQueue.main.async {
                self.albumImage.image = image
                self.albumImageActivityView.isHidden = true
                self.albumImageActivityView.stopAnimating()
            }
        }
    }
    
    func  setLables (album:Album) {
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
