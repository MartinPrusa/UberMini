//
//  CLLocationCoordinate2D+Extensions.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

extension CLLocationCoordinate2D {
    func moveLocation(by value: Double) -> CLLocationCoordinate2D {
        let lat = latitude + value
        let lon = longitude + value
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
