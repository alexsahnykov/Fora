//
//  TrackModel.swift
//  Fora
//
//  Created by Александр Сахнюков on 26/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import Foundation

struct Track: Decodable {
    var trackName: String?
    var trackNumber: Int?
}
struct  Tracks: Decodable {
    let results: [Track]
}
