//
//  MainViewController.swift
//  Fora
//
//  Created by Александр Сахнюков on 20/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchingAlbums =  [Album]()
    let dataProvider = DataProvider()
    
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
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchingAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCollectionViewCell
        cell.updateCell(album: searchingAlbums[indexPath.row])
        cell.fileImage.image = nil
        dataProvider.downloadImage(url: searchingAlbums[indexPath.row].artworkUrl100!)  { image in
            cell.image  = image
        }
        return cell
    }
}


extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumForSegue = searchingAlbums[indexPath.row]
        let aboutVc = storyboard?.instantiateViewController(withIdentifier: "albumInfo") as! AlbumDetailTableViewController
        aboutVc.albumDetail = albumForSegue
        aboutVc.dataProvider = dataProvider
        self.navigationController?.pushViewController(aboutVc, animated: true)
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            startActivityView()
            self.searchingAlbums.removeAll()
            networkManager.fetchSearchingAlbums(albumSearch: searchBar.text!) { [weak self] (albums) in
                guard let self = self else { return }
                if albums.results.isEmpty {
                    self.insertNoResultPage()
                } else {
                    self.getSearchResult(albumsSearchResult: albums)
                }
            }
        } else {
            return
        }
        searchBar.resignFirstResponder()
    }
    
    func  insertNoResultPage() {
        DispatchQueue.main.async {
            self.stopActivityView()
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
    
    func getSearchResult(albumsSearchResult:Albums)  {
        self.searchingAlbums = albumsSearchResult.results.sorted(by: {$0.collectionName! < $1.collectionName!})
        DispatchQueue.main.async {
            self.collectionVIew.backgroundView = nil
            self.collectionVIew.reloadData()
            self.collectionVIew.setContentOffset(CGPoint(x:0,y:0), animated: false)
            self.stopActivityView()
        }
    }
    
    func startActivityView () {
        self.searchActivity.isHidden = false
        self.searchActivity.startAnimating()
    }
    
    func stopActivityView () {
        self.searchActivity.isHidden = true
        self.searchActivity.stopAnimating()
    }
}
