//
//  NetworkManager.swift
//  Fora
//
//  Created by Александр Сахнюков on 21/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//



import Foundation
import UIKit

let albumSearchUrl = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&offset=0&limit=100&term="
let albumsSongs = "https://itunes.apple.com/lookup?entity=song&id="


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
    

    static func fetchSearchingAlbums(searchAlbum:String, completion: @escaping (_ albums: Albums)->()) {
        guard let url = URL(string: (albumSearchUrl+searchAlbum).encodeUrl) else { return }
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
    
    static func fetchAlbumTracks(albumID:String, completion: @escaping (_ tracks: Tracks)->()) {
        guard let url = URL(string: albumsSongs+albumID) else { return }
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
    
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
            } .resume()
    }
}
