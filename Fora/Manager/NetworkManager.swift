//
//  NetworkManager.swift
//  Fora
//
//  Created by Александр Сахнюков on 21/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//



import Foundation
import UIKit


class networkManager {
    private init() {}
    
    static func getRequest(url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    
    static func fetchSearchingAlbums(albumSearch: String, completion: @escaping (_ albums: Albums)->()) {
        let searchUrl = SearchUrl.getSearchingAlbumsURL(withAlbumName: albumSearch).url
        guard let url = searchUrl else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let albums = try JSONDecoder().decode(Albums.self, from: data)
                completion(albums)
            } catch let error {
                print("Error serialization json", error.localizedDescription)
            }
            }.resume()
    }
    
    static func fetchAlbumTracks(albumID: String, completion: @escaping (_ tracks: Tracks)->()) {
        let searchUrl = SearchUrl.getAlbumTracksURL(withAlbumId: albumID).url
        guard let url = searchUrl else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let albums = try JSONDecoder().decode(Tracks.self, from: data)
                completion(albums)
            } catch let error {
                print("Error serialization json", error)
            }
            }.resume()
    }
    
    
    static func fetchImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else {
            let image = UIImage(named: "NoAlbumImage")
            completion(image!)
            return  }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                let image = UIImage(named: "NoAlbumImage")
                return  completion(image!)
            }
            completion(image)
            } .resume()
    }
}
