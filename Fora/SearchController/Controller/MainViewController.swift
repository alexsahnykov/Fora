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
    
    @IBOutlet var dataProvider: DataProviderSearchView!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.searchActivity.isHidden = true
    }
}

    // MARK: - SearchBAr methods
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            startActivityView()
            self.getAlbums(albumName: searchBar.text!)
        }
    }
    
    func getAlbums(albumName: String) {
        self.dataProvider.dataManager.searchingAlbums.removeAll()
        networkManager.fetchSearchingAlbums(albumSearch: albumName) { [weak self] (albums) in
            guard let self = self else { return }
            self.setSearchResult(albumsSearchResult: albums)
            DispatchQueue.main.async {
                if  self.dataProvider.dataManager.searchingAlbums.isEmpty  {
                    self.insertNoResultPage()
                } else {
                    self.collectionVIew.reloadData()
                }
            }
        }
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
    
    func setSearchResult(albumsSearchResult:Albums)  {
        self.dataProvider.dataManager.searchingAlbums = albumsSearchResult.results.sorted(by: {$0.collectionName! < $1.collectionName!})
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
