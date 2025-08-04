//
//  LocationManager.swift
//  Rekindle
//
//  Created by Vera Nur on 4.08.2025.
//

// LocationManager.swift
import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  @Published var locationName: String?

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func requestLocation() {
    manager.requestWhenInUseAuthorization()
    manager.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
    guard let loc = locs.first else { return }
    CLGeocoder().reverseGeocodeLocation(loc) { pms, _ in
      if let pm = pms?.first {
        let parts = [pm.locality, pm.administrativeArea, pm.country].compactMap { $0 }
        let name = parts.joined(separator: ", ")
        DispatchQueue.main.async { self.locationName = name }
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("🔴 Location error:", error)
  }
}
