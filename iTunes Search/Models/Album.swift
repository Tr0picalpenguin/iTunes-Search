//
//  Album.swift
//  iTunes Search
//
//  Created by Scott Cox on 6/26/22.
//

import Foundation

struct TopLevelAlbums: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    let results: [Album]
}
struct Album: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title = "collectionName"
        case trackCount = "trackCount"
        case albumImage = "artworkUrl100"
        case albumID = "collectionId"
    }
    
    let title: String
    let trackCount: Int
    let albumImage: String?
    let albumID: Int
}




