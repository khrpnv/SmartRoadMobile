//
//  MapViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/23/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import MapKit
import LanguageManager_iOS

class MapViewController: UIViewController {
  
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var infoButton: UIButton!
  @IBOutlet private weak var closeButton: UIButton!
  
  private let locationManager = CLLocationManager()
  private var mapIsSet: Bool = false
  private var routeInfo: RouteInfo? = nil
  
  var destinationPoint: ServiceStation? = nil
  var sourceLocation: CLLocationCoordinate2D? = nil {
    didSet {
      if mapIsSet { return }
      setupMap()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLocationManager()
  }
  
  @IBAction func closeScreen(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func showInfo(_ sender: Any) {
    let currentLanguage = LanguageManager.shared.currentLanguage
    let title = currentLanguage == .en ? "Info" : "Інформація"
    var message = ""
    guard let info = self.routeInfo else { return }
    switch currentLanguage {
    case .en:
      message = "Route distance: \(info.distance) km\nApproximate travel time: \(Int(info.travelTime)) minutes"
    default:
      message = "Довжина маршруту: \(info.distance) км\nПриблизний час подорожі: \(Int(info.travelTime)) хвилин"
    }
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(alertAction)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Private
private extension MapViewController {
  func setupView() {
    if let closeImage = UIImage(named: Const.Image.close)?.withRenderingMode(.alwaysTemplate) {
      closeButton.tintColor = .white
      closeButton.setBackgroundImage(closeImage, for: .normal)
    }
    
    if let infoImage = UIImage(named: Const.Image.info)?.withRenderingMode(.alwaysTemplate) {
      infoButton.tintColor = .white
      infoButton.setBackgroundImage(infoImage, for: .normal)
    }
  }
  
  func setupMap() {
     mapView.delegate = self
     let currentLanguage = LanguageManager.shared.currentLanguage
     guard
       let station = destinationPoint,
       let sourceLocation = sourceLocation
     else {
       return
     }
     mapIsSet = true
     let destinationLocation = CLLocationCoordinate2D(latitude: station.latitude,
                                                      longitude: station.longtitude)
     
     let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
     let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
     
     let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
     let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
     
     let sourceAnnotaion = MKPointAnnotation()
     sourceAnnotaion.title = currentLanguage == .en ? "You" : "Ви"
     if let location = sourcePlacemark.location {
       sourceAnnotaion.coordinate = location.coordinate
     }
     
     let destinationAnnotaion = MKPointAnnotation()
     destinationAnnotaion.title = station.name
     if let location = destinationPlacemark.location {
       destinationAnnotaion.coordinate = location.coordinate
     }
     
     self.mapView.showAnnotations([sourceAnnotaion, destinationAnnotaion], animated: true)
     
     let directionRequest = MKDirections.Request()
     directionRequest.source = sourceMapItem
     directionRequest.destination = destinationMapItem
     directionRequest.transportType = .automobile
     
     let directions = MKDirections(request: directionRequest)
     
     directions.calculate { (response, error) in
       guard let response = response else {
         if let error = error {
           print("Error: \(error)")
         }
         return
       }
       let route = response.routes[0]
       
       let routeDistance = route.distance / 1000.0
       let travelTime = route.expectedTravelTime / 60
       self.routeInfo = RouteInfo(distance: routeDistance.rounded(toPlaces: 2), travelTime: travelTime.rounded(toPlaces: 0))
       
       self.mapView.addOverlay((route.polyline), level: .aboveRoads)
       
       let rect = route.polyline.boundingMapRect
       self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
     }
   }
   
   func setupLocationManager() {
     self.locationManager.requestAlwaysAuthorization()
     self.locationManager.requestWhenInUseAuthorization()
     if CLLocationManager.locationServicesEnabled() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
       locationManager.startUpdatingLocation()
     }
   }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = Const.Color.textFieldFocusColor
    renderer.lineWidth = 6.0
    return renderer
  }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    self.sourceLocation = locValue
  }
}
