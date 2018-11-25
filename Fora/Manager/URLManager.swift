//
//  URLManager.swift
//  Fora
//
//  Created by Александр Сахнюков on 25/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import Foundation

struct SearchUrl {
    let path: String
    let queryItems: [URLQueryItem]
    
}

extension SearchUrl {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    static func getSearchingAlbumsURL(withAlbumName query: String) -> SearchUrl {
        return SearchUrl(
            path: "/search",
            queryItems: [
                URLQueryItem(name: "entity", value: "album"),
                URLQueryItem(name: "attribute", value: "albumTerm"),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "term", value: query)]
        )
    }
    
    static func getAlbumTracksURL(withAlbumId query: String) -> SearchUrl {
        return SearchUrl(
            path: "/lookup",
            queryItems: [
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "id", value: query)]
        )
    }
}
