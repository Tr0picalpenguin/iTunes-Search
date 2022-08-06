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
    
    var time: String {
        var timeMillis = ""
        if let trackTime = self.trackTimeMillis {
            timeMillis = String(trackTime)
        } else {
            timeMillis = "no time available"
        }
        
        let timeMillisInt = Int(timeMillis)!
        let timeSec = timeMillisInt / 1000
        let timeMin = timeSec / 60
        let remainder = timeSec % 60
        
        var finalTime = String("\(timeMin):\(remainder)")
        
        if remainder < 10 {
            finalTime = String("\(timeMin):0\(remainder)")
        }
        return finalTime
    }
}
