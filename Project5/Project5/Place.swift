//
//  Place.swift
//  Project5
//
//  Created by Vincent Lin on 2/7/25.
//

import Foundation
import MapKit

class Place: MKPointAnnotation,Decodable {
    // Name of the point of interest
    var name: String?
    
    // Description of the point of interest
    var longDescription: String?
  
    
}
