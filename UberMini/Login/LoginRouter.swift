//
//  LoginRouter.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol LoginRoutingLogic {
    func navigateToMap()
}

protocol LoginDataPassing: AnyObject {
    var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {

    weak var viewController: LoginViewController?
    weak var dataStore: LoginDataStore?

    // MARK: - Navigation

    func navigateToMap() {
        let mapVC = MapViewController(nibName: nil, bundle: nil)
        mapVC.router.dataStore?.username = dataStore?.username
        viewController?.navigationController?.pushViewController(mapVC, animated: true)
    }
}
