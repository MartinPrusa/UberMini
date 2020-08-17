//
//  UpdatableAnnotation.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//

import Foundation
import MapKit.MKAnnotation

final class UpdatableAnnotation: MKPointAnnotation {
    private var timer: Timer?
    private var updateCounter = 0
    func startUpdateLocation() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
                let newCoordinate = self.coordinate.moveLocation(by: 0.001)
                let oldCoordinate = self.coordinate.moveLocation(by: -0.001)

                if self.updateCounter%2 == 0 {
                    self.coordinate = newCoordinate
                } else {
                    self.coordinate = oldCoordinate
                }

                self.updateCounter += 1
            })
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
