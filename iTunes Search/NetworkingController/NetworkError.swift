//
//  NetworkError.swift
//  iTunes Search
//
//  Created by Scott Cox on 6/26/22.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL(String)
    case noData
    case thrownError(Error)
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "The server responded with no data. Try again."
        case .unableToDecode:
            return "Unable to decode the object. Check the data from your endpoint."
        case .invalidURL(let urlString):
            return "Unable to reach the server. Check the url \(urlString)"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        }
    }
}
