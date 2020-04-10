//
//  MapViewController.swift
//  KafeShowSwift5
//
//  Created by v on 09.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address:String?)
}



class MapViewController: UIViewController {
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place: Place?
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000.0
    var incomeSegueIdentifier = ""
    var placeCoordinate: CLLocationCoordinate2D?
    var directionsArray: [MKDirections] = []
    var previousLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
        }
    }
    
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagePinMap: UIImageView!
    @IBOutlet weak var labelAddressUser: UILabel!
    @IBOutlet weak var buttonTakeAddress: UIButton!
    @IBOutlet weak var buttonGoToPlace: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAddressUser.text = ""
        mapView.delegate = self
        checkLocationServices()
        setupMapView()
    }
    
    @IBAction func closeMapVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionMyLocation() {
        showUserLocation()
    }
    
    @IBAction func actionTakeAddressButton(_ sender: UIButton) {
        mapViewControllerDelegate?.getAddress(labelAddressUser.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionGoToPlace(_ sender: UIButton) {
            
        getDirations()
    }
    
    
    private func setupMapView(){
        buttonGoToPlace.isHidden = true
        if self.incomeSegueIdentifier == "getAddress" {
            showUserLocation()
//            imagePinMap.isHidden = false
//            labelAddressUser.isHidden = false
//            buttonTakeAddress.isHidden = false
        } else {
            setupPlacemark()
            imagePinMap.isHidden = true
            labelAddressUser.isHidden = true
            buttonTakeAddress.isHidden = true
            buttonGoToPlace.isHidden = false
            
            
        }
    }
    private func resetMapView(withNew directions: MKDirections){
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
        
    }
    
    private func setupPlacemark(){
        guard let location = place?.locatin else {return}
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place?.name
            annotation.subtitle = self.place?.type
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
        
    }

    private func getDirations(){
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        guard let request = createDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        let direction = MKDirections(request: request)
        resetMapView(withNew: direction)
        direction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance/1000)
                let timeInterval = String(format: "%.1f", route.expectedTravelTime/60)
                
                print("Distance = \(distance) km, and time in way = \(timeInterval) minutes")
                
            }
            
            
            
        }
    }
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else {return nil}
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let endLocation = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: endLocation)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
}
// MARK: Annotation impruve
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        if let imageDta = place?.imageDate {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageDta)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showUserLocation()
            }
        }
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            let city = placemark?.subAdministrativeArea
            let country = placemark?.country
        
            DispatchQueue.main.async {
                self.labelAddressUser.text = "\(country ?? ""), \(city ?? ""), \(streetName ?? ""), \(buildNumber ?? "")"
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}
// MARK: Location User
extension MapViewController {
    // check is on/of in user device servises geolocation?
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Servise are Disabled",
                    message: "To enable it go: Settings -> Privacy -> Location Services and turn On"
                )
            }
        }
    }
    private func showAlert(title: String, message: String){
        // alert controller: requerst to on geolocation
        let acGeo = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        acGeo.addAction(alertActionOk)
        present(acGeo, animated: true, completion: nil)
    }
    
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" {showUserLocation()}
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Servise are Disabled",
                    message: "To enable it go: Settings -> Privacy -> Location Services and turn On"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Servise are Disabled",
                    message: "To enable it go: Settings -> Privacy -> Location Services and turn On"
                )
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("some error if Geo Location")
        }
    }
    
    private func getCenterLocation( for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    func showUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    private func startTrackingUserLocation(){
        guard let previouseLocation = previousLocation else {return}
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previouseLocation) > 50 else {return}
        self.previousLocation = center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
            
        }
        
    }
}
// MARK: hot localization
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
