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
    var image = UIImage()
    
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
        setLables(album: albumDetail)
        setLoadingScreen()
        fetchTracks()
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
        networkManager.fetchAlbumTracks(albumID:String(albumDetail.collectionId!)) { tracks in
            self.albumTracks = tracks.results
            self.albumTracks.removeFirst()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
        }
        
    }
    
    // MARK: - UI
    
    func  setLables (album:Album) {
        artistLable.text = album.artistName
        albumLable.text = album.collectionName
        countryLable.text = album.country
        dateLable.text = album.releaseDate
        albumImage.image = image
    }
    
    
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    private func setLoadingScreen() {
        self.tableView.separatorColor = .white
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Загрузка..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        tableView.addSubview(loadingView)
    }
}
