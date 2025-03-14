//
//  FavoritesViewController.swift
//  Project5
//
//  Created by Vincent Lin on 2/8/25.
//

import UIKit

protocol PlacesFavoritesDelegate: AnyObject {
    func favoritePlaceSelected(name: String)
    func unfillStar()
}

class FavoritesViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    var favoritePlaces: [String] = []
    weak var delegate: PlacesFavoritesDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadFavorites()
        view.addSubview(tableView)
   }
    
    func loadFavorites() {
        favoritePlaces = Array(DataManager.sharedInstance.listFavorites()).sorted()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favoritePlaces[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlaceName = favoritePlaces[indexPath.row]
        delegate?.favoritePlaceSelected(name: selectedPlaceName)
        dismiss(animated: true)
    }
    
    // swipe to delete a。row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let placeName = favoritePlaces[indexPath.row]
            
            DataManager.sharedInstance.removeFavorite(name: placeName)
    
            favoritePlaces.remove(at: indexPath.row)
            delegate?.unfillStar()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func TapToDimiss(_ sender: Any) {
        dismiss(animated: true)
    }
   
}
