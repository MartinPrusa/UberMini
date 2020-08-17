//
//  CLLocation+Extension.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//

import CoreLocation

typealias StreetNameHandler = (String?) -> Void

extension CLLocation {
    func streetName(completionBlock: @escaping StreetNameHandler) {
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            if error == nil, placemarks?.isEmpty == false, let placemark = placemarks?.first {
                let address = "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"

                completionBlock(address)
            } else {
                completionBlock(nil)
            }
        }
    }
}
