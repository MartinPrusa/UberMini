//
//  MapInteractor.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol MapBusinessLogic {
}

protocol MapDataStore: AnyObject {
    var username: String! { get set }
}

final class MapInteractor: MapBusinessLogic, MapDataStore {

    var presenter: MapPresentationLogic!
    private var _username: String!
    var username: String! {
        get {
            return _username
        } set {
            _username = newValue
            updateUsername()
        }
    }

    private func updateUsername() {
        presenter.present(response: .init(username: username))
    }
}
