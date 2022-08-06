//
//  Track.swift
//  iTunes Search
//
//  Created by Scott Cox on 6/26/22.
//

import Foundation

struct TopLevelTracks: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    let results: [Track]
}

struct Track: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case albumID = "collectionId"
        case albumTitle = "collectionName"
        case kind = "kind"
        case trackTimeMillis = "trackTimeMillis"
    }
    
    let title: String?
    let albumID: Int
    let albumTitle: String
    let kind: String?
    let trackTimeMillis: Int?
}
