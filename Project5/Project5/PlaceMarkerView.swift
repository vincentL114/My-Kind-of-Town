//
//  PlaceMarkerView.swift
//  Project5
//
//  Created by Vincent Lin on 2/7/25.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
      willSet {
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemRed
        titleVisibility = .visible
        glyphImage = UIImage(systemName: "pin.fill")
      }
  }
}
