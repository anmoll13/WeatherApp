//
//  LocationManager.swift
//  SwiftUI-Weather
//
//  Created by Anmol Singh on 5/15/23.
//

import Foundation
import CoreLocation

//this class manages and updates the user location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location:CLLocationCoordinate2D? //@published to allow it to be observed for changes
    @Published var isLoading = false //used to indicate when loading is in progress
    
    override init(){
        super.init();
        manager.delegate = self
    }
    
    // This function requests the user's location and sets the isLoading property to true
    func requestLocation(){
        isLoading = true
        manager.requestLocation()
    }
    
    // This function is called when the location is updated and updates the location property with the new coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    // This function is called when there is an error in receiving the location and prints an error message to the console.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error receiving location", error)
        isLoading = false
    }
}
