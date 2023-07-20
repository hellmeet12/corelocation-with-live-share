//
//  ContentView.swift
//  CoreLocationSwiftUITutorial
//
//  Created by Cole Dennis on 9/20/22.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State var text = "Live Location Not Active Yet"
    @State var timeRemaining = 100
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                Text("Your current location is:")
                Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                Text("Altitude: \("\(locationDataManager.altitude ?? 0.0)" )")
                
                
                Button(action: {
                    timeRemaining = 100
                    locationDataManager.doSomeMagic()
                    timer.upstream.connect().cancel()
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                }, label: {
                    Text("Start Updating live Location for 100 second")
                })
                .padding(.top, 16)
                
                Button(action: {
                    locationDataManager.doSomeMagic()
                }, label: {
                    Text("Start Updating live Location")
                })
                .padding(.top, 16)
                
                
                Button(action: {
                    locationDataManager.stopLiveLocation()
                }, label: {
                    Text("Stop Updating Live Location")
                })
                .padding(.top, 16)
                
                Text(text)
                    .padding(.top, 16)
                    .onReceive(timer) { _ in
                        text = "time remaining \(timeRemaining)"
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }else{
                            text = "Live Location Not Active Yet"
                            
                            timer.upstream.connect().cancel()
                            locationDataManager.stopUpdating()
                        }
                    }
                
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                Text("Current location data was restricted or denied.")
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }.onAppear{
            
            timer.upstream.connect().cancel()
        }
    }
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
