//
//  AlbumDetailViewController.swift
//  iTunes Search
//
//  Created by Scott Cox on 7/30/22.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var trackCountLabel: UILabel!
    
    @IBOutlet weak var trackLisstTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackLisstTableView.dataSource = self
        updateViews()
    }
    
    var album: Album?
    var tracks: [Track]?
    
    func updateViews() {
        guard let album = album else { return }
        self.albumTitleLabel.text = album.title
        self.trackCountLabel.text = "\(album.trackCount) songs"
        if let albumImage = album.albumImage {
            fetchImage(with: albumImage)
        }
        fetchTracks()
        
    }
    
    func fetchTracks() {
        guard let album = album else { return }
        NetworkController.fetchTracks(with: album.albumID) { result in
            switch result {
            case .failure(let error):
                print(error.errorDescription!)
            case .success(let tracks):
                DispatchQueue.main.async {
                    self.tracks = tracks
                    self.trackLisstTableView.reloadData()
                }
            }
        }
    }
    
    func fetchImage(with imagePath: String) {
        NetworkController.fetchAlbumImage(with: imagePath) { result in
            switch result {
            case .failure(let error):
                print(error.errorDescription!)
            case .success(let image):
                DispatchQueue.main.async {
                    self.albumImageView.image = image
                }
            }
        }
    }
    
} // End of class

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        guard let tracks = tracks else {return UITableViewCell()}
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.title
        cell.detailTextLabel?.text = "\(track.trackTimeMillis)"
        return cell
    }
}
