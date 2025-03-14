//
//  ViewController.swift
//  Project5
//
//  Created by Vincent Lin on 2/6/25.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var annotations: [Place] = []
    var selectedPlace: Place?
    
    @IBOutlet weak var hudTitle: UILabel!
    @IBOutlet weak var hudDescription: UILabel!
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoritePlaceButton: UIButton!
    
    let locationManage = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        loadAnnotations()
        initHUD()
        initFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let viewRegion = DataManager.sharedInstance.loadRegionFromPlist() {
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    
    func loadAnnotations() {
        annotations = DataManager.sharedInstance.loadAnnotationFromPlist()
        
        for place in annotations {
            place.title = place.name
            mapView.addAnnotation(place)
        }
    }
    
    func initHUD(){
        guard let place = annotations.first else {return}
        
        hudTitle.textColor = .white
        hudTitle.adjustsFontSizeToFitWidth = true
        hudTitle.minimumScaleFactor = 0.5 // Text can shrink up to 50%
        hudTitle.numberOfLines = 1
        
        hudDescription.textColor = .darkGray
        
        hudView.layer.cornerRadius = 12
        
        setUpHUD(place)
    }
    
    func initFavoriteButton(){
        var config = UIButton.Configuration.filled()
        config.title = "FAVORITE PLACES"
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .systemYellow
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var newAttributes = attributes
            newAttributes.font = UIFont.systemFont(ofSize: 33, weight: .bold)
            return newAttributes
        }
        favoritePlaceButton.configuration = config
        favoritePlaceButton.layer.cornerRadius = 12
        
    }
    
    @IBAction func favoritePlaceButtonTapped(_ sender: Any) {
        let favoritesViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        favoritesViewController.delegate = self
        
        if let sheet = favoritesViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                //sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
            present(favoritesViewController, animated: true, completion: nil)

    }
    
    @IBAction func addFavorite(_ sender: Any) {
        guard let place = selectedPlace else { return }
        let placeName = place.name ?? "Unknown Place"
        
        if DataManager.sharedInstance.isFavorite(name: placeName) {
            DataManager.sharedInstance.removeFavorite(name: placeName)
            unfillStar()
            
        } else {
            DataManager.sharedInstance.saveFavorite(name: placeName)
            fillStar()
        }
        // Update the table if it is open
        if let favoritesVC = self.presentedViewController as? FavoritesViewController {
            favoritesVC.loadFavorites() 
        }
    }
    
    // set the favorite star fill or not
    func setStarStatus(_ place:Place){
        let placeName = place.name ?? "Unknown Place"
        if DataManager.sharedInstance.isFavorite(name: placeName) {
            fillStar()
        } else {
            unfillStar()
        }
    }
    
    func fillStar() {
        star.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    func unfillStar() {
        star.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    func getAnnotation(named name: String) -> Place? {
        for annotation in mapView.annotations {
            if let place = annotation as? Place, place.name == name {
                return place
            }
        }
        return nil
    }
    
    func setUpHUD(_ place:Place){
        selectedPlace = place
        hudTitle.text = place.name
        hudDescription.text = place.longDescription
        
        setStarStatus(place)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                for: annotation) as? PlaceMarkerView
        
        let identifier = "PlaceMarker"
        
        if annotationView == nil {
            annotationView = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
        } 
   
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = view.annotation as? Place {
            setUpHUD(place)
        }
    }
}

extension ViewController: PlacesFavoritesDelegate {
    func favoritePlaceSelected(name: String) {
        if let place = getAnnotation(named: name) {
            let region = MKCoordinateRegion(center: place.coordinate,
                                            latitudinalMeters: 250,
                                            longitudinalMeters: 250)
            mapView.setRegion(region, animated: true)
            setUpHUD(place)
        }
    }
}





