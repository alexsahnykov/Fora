//
//  NetworkManager.swift
//  Fora
//
//  Created by Александр Сахнюков on 21/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//



import Foundation
import UIKit



struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
}

extension Endpoint {
    static func searchAlbums(albumName query: String) -> Endpoint {
        return Endpoint(
            path: "/search",
            queryItems: [
                URLQueryItem(name: "entity", value: "album"),
                URLQueryItem(name: "attribute", value: "albumTerm"),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "term", value: query)]
        )
    }
    static func getAlbumTracks(albumId query: String) -> Endpoint {
        return Endpoint(
            path: "/lookup",
            queryItems: [
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "id", value: query)]
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

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
    
    
    static func fetchSearchingAlbums(endpoint: Endpoint, completion: @escaping (_ albums: Albums)->()) {
        guard let url = endpoint.url else { return }
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
    
    static func fetchAlbumTracks(endpoint: Endpoint, completion: @escaping (_ tracks: Tracks)->()) {
        guard let url = endpoint.url else { return }
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
