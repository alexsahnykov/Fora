//
//  File.swift
//  Fora
//
//  Created by Александр Сахнюков on 21/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import Foundation

struct Album: Decodable {
    
    let artistName: String?
    var artworkUrl100: String?
    let collectionId: Int?
    let collectionName: String?
    let country: String?
    let primaryGenreName: String?
    let releaseDate: String?
    
}
struct  Albums: Decodable {
    let results: [Album]
}

