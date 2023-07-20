//
//  swift
//  CoreLocationSwiftUITutorial
//
//  Created by Cole Dennis on 9/21/22.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var altitude: Double? = 0.0
    var counter = 10
    
    var isCalled = true
    var secondsElapsed = 0 // if < 0 then timer is stopped
    var timer :Timer? = nil
          
    override init() {
        super.init()
        locationManager.delegate = self
    }
    

    func doSomeMagic(){
        timer?.invalidate()
        timer = nil
        stopUpdating()
        isCalled = true
        timer =  Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.startUpdating()

            if !self.isCalled {
                self.stopLiveLocation()
                
            }
        }
    }
    
    func stopLiveLocation(){
        self.isCalled = false
        timer?.invalidate()
        timer = nil
        stopUpdating()
    
    }
   @objc func startUpdating() {
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating(){
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
        guard let lastLocation = locations.last else {
            NSLog("error no last location")
            return
        }
        altitude = lastLocation.altitude
        print("update location")
        
        let userLocation = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        let destinationLocation = CLLocation(latitude: -6.168120 , longitude: 106.787166)
        let distance = userLocation.distance(from: destinationLocation)
        print("distance: \(String(format: "%.2f", distance)) M")
        stopUpdating()

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
}

