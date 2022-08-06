//
//  AlbumTableViewCell.swift
//  iTunes Search
//
//  Created by Scott Cox on 7/30/22.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var trackCountLabel: UILabel!
    
    
    
    override func prepareForReuse() {
        albumImageView.image = nil
    }
    
    func updateViews(for album: Album) {
        guard let albumImage = album.albumImage else { return }
        NetworkController.fetchAlbumImage(with: albumImage) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let image):
                DispatchQueue.main.async {
                    self.albumImageView.image = image
                    self.albumNameLabel.text = album.title
                    self.trackCountLabel.text = "\(album.trackCount) songs"
                }
            }
        }
    }
}
