//
//  MapRouter.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol MapRoutingLogic {

}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get }
}

final class MapRouter: MapRoutingLogic, MapDataPassing {

    weak var viewController: MapViewController?
    weak var dataStore: MapDataStore?

}
