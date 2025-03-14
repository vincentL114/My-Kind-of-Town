//
//  DataManager.swift
//  Project5
//
//  Created by Vincent Lin on 2/7/25.
//

import Foundation
import CoreLocation
import MapKit

public class DataManager {
  
  public static let sharedInstance = DataManager()
  
  //This prevents others from using the default '()' initializer
  fileprivate init() {}

    // Load annotations from Data.plist
  func loadAnnotationFromPlist() -> [Place]  {
      var places: [Place] = []
      if let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
         let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
         let placesArray = plist["places"] as? [[String: Any]] {
          
          for dict in placesArray {
              let place = Place()
              place.name = dict["name"] as? String
              place.longDescription = dict["description"] as? String
              
              if let latitude = dict["lat"] as? CLLocationDegrees,
                 let longitude = dict["long"] as? CLLocationDegrees {
                  place.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              }
              
              places.append(place)
          }
      }
      return places
    }
    
    func loadRegionFromPlist() -> MKCoordinateRegion? {
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
           let array = plist["region"] as? [Double], array.count == 4 {

            let center = CLLocationCoordinate2D(latitude: array[0], longitude: array[1])
            let span = MKCoordinateSpan(latitudeDelta: array[2], longitudeDelta: array[3])
            
            return MKCoordinateRegion(center: center, span: span)
        }

        return nil
    }
    
    func saveFavorite(name: String) {
        var favorites = listFavorites()
        favorites.insert(name)
        UserDefaults.standard.set(Array(favorites), forKey: "favorites")
    }
    
    func removeFavorite(name: String) {
        var favorites = listFavorites()
        favorites.remove(name)
        UserDefaults.standard.set(Array(favorites), forKey: "favorites")
    }
        
    func listFavorites() -> Set<String>{
        if let array = UserDefaults.standard.array(forKey: "favorites") as? [String] {
            return Set(array)
        }
        return []
    }
    
    func isFavorite(name: String) -> Bool {
        return listFavorites().contains(name)
    }

}
