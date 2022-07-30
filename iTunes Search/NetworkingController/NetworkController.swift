//
//  NetworController.swift
//  iTunes Search
//
//  Created by Scott Cox on 6/26/22.
//

import Foundation
import UIKit

struct NetworkController {
    
    // MARK: - Create the URL
    static let baseURL = "https://itunes.apple.com"
    
    // MARK: - URL to fetch the albums - Endpoint 1
    static func fetchAlbums(with searchTerm: String, completion: @escaping (Result<TopLevelAlbums, NetworkError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else {
            completion(.failure(.invalidURL(baseURL)))
            return
        }
        
        let searchKey = URLQueryItem(name: "term", value: searchTerm)
        let entityKey = URLQueryItem(name: "entity", value: "album")
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/search"
        urlComponents?.queryItems = [searchKey, entityKey]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL("Error with Album url")))
            return
        }
            print(finalURL)
            
            URLSession.shared.dataTask(with: finalURL) { data, _, error in
                if let error = error {
                    completion(.failure(.thrownError(error)))
                    print("Encountered Error: \(error.localizedDescription)")
                }
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let albumData = try JSONDecoder().decode(TopLevelAlbums.self, from: data)
                    completion(.success(albumData))
                } catch {
                    completion(.failure(.thrownError(error)))
                    return
                }
            }.resume()
    }
    
    // MARK: - URL to fetch the tracks - Endpoint 2
    static func fetchTracks(with albumID: Int, completion: @escaping (Result<[Track],NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: baseURL) else {
            completion(.failure(.invalidURL(baseURL)))
            return
        }
        let entity = URLQueryItem(name: "entity", value: "song")
        let albumID = URLQueryItem(name: "id", value: String(albumID))
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/lookup"
        urlComponents?.queryItems = [entity, albumID]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL("Error with the Album url")))
            return
        }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                print("Encountered Error: \(error.localizedDescription)")
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let trackData = try JSONDecoder().decode(TopLevelTracks.self, from: data)
                let trackArray = trackData.results.filter { $0.kind == "song" }
                completion(.success(trackArray))
            } catch {
                completion(.failure(.thrownError(error)))
                return
            }

        }.resume()
    }
    
    // MARK: - URL to fetch the image - Endpoint 3
    static func fetchAlbumImage(with albumImage: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let imageURL = URL(string: albumImage) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let albumImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return
        }
            completion(.success(albumImage))
        }.resume()
    }
    
}// end of struct
