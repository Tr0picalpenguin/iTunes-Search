//
//  AlbumTableViewController.swift
//  iTunes Search
//
//  Created by Scott Cox on 7/30/22.
//

import UIKit

class AlbumTableViewController: UITableViewController {

    @IBOutlet weak var albumSearchBar: UISearchBar!
    
    var albums: [Album] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        albumSearchBar.delegate = self
  
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        let album = albums[indexPath.row]
        cell.updateViews(for: album)
        return cell
    }
  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? AlbumDetailViewController else { return }
        let album = albums[indexPath.row]
        destination.album = album
    }
    

}

extension AlbumTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        NetworkController.fetchAlbums(with: searchTerm) { [weak self] result in
            switch result {
            case.success(let topLevelDict):
                DispatchQueue.main.async {
                    self?.albums = topLevelDict.results
                    self?.albumSearchBar.text = ""
                }
            case.failure(let searchError):
                print(searchError.errorDescription!)
            }
        }
    }
}
