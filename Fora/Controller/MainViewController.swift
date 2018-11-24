//
//  MainViewController.swift
//  Fora
//
//  Created by Александр Сахнюков on 20/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    // MARK: - Properties
    
    
    var searchingAlbums =  [Album]()
    var albumInfo :Album?
    var albumImage: UIImage?
    
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    // MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        self.searchActivity.isHidden = true
    }
    
    // MARK: - CollectionView methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchingAlbums.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCollectionViewCell
        cell.updateCell(album: searchingAlbums[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumForSegue = searchingAlbums[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! FilmCollectionViewCell
        albumImage = cell.fileImage.image
        self.albumInfo = albumForSegue
        self.performSegue(withIdentifier: "showDetail", sender: self)
        searchBar.resignFirstResponder()
    }
   
    
    // MARK: - CollectionView methods
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
           if let destinationVC = segue.destination as? AlbumDetailTableViewController {
            destinationVC.albumDetail = self.albumInfo
            destinationVC.image = albumImage!
        }
    }
    }
    
      // MARK: - SearchView methods
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            self.searchActivity.isHidden = false
            self.searchActivity.startAnimating()
            self.searchingAlbums.removeAll()
            networkManager.fetchSearchingAlbums(endpoint: .searchAlbums(albumName: searchBar.text!)) { (albums) in
                if albums.results.isEmpty {
                    self.noResultPage()
                } else {
                    self.searchResult(albumsSearchResult: albums)
                }
            }
        } else {
            return
        }
        searchBar.resignFirstResponder()
    }
    
    func  noResultPage() {
        DispatchQueue.main.async {
            self.searchActivity.isHidden = true
            self.searchActivity.stopAnimating()
            self.collectionVIew.reloadData()
            self.collectionVIew.setContentOffset(CGPoint(x:0,y:0), animated: false)
            let noDataLablePosition = CGRect(x: 0,y: 0,width: self.collectionVIew.bounds.size.width,height: self.collectionVIew.bounds.size.height)
            let noDataLabel: UILabel = UILabel(frame: noDataLablePosition)
            noDataLabel.text = "No search result  :("
            noDataLabel.textAlignment = .center
            noDataLabel.textColor = UIColor.gray
            noDataLabel.sizeToFit()
            self.collectionVIew.backgroundView = noDataLabel
        }
    }
    
    func searchResult(albumsSearchResult:Albums)  {
        self.searchingAlbums = albumsSearchResult.results.sorted(by: {$0.collectionName! < $1.collectionName!})
        DispatchQueue.main.async {
            self.collectionVIew.backgroundView = nil
            self.collectionVIew.reloadData()
            self.collectionVIew.setContentOffset(CGPoint(x:0,y:0), animated: false)
            self.searchActivity.isHidden = true
            self.searchActivity.stopAnimating()
        }
    }
}
