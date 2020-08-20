//
//  FirebaseConnector.swift
//  UberMini
//
//  Created by Martin Prusa on 20.08.2020.
//

import Foundation
import Firebase

protocol FCDelegate: class {
    func itemDataDidChange(item: Result<Item, FCError>)
}

enum FCError: Error {
    case itemIdNotFound(Double)
    case itemCannotBeUpdated(Double)
}

struct Item {
}

final class FirebaseConnector {

    static let shared = FirebaseConnector()

    private let ref = Database.database().reference()

    private var observing = false

    weak var delegate: FCDelegate?

    typealias returnClosure = (_ result: Result<Item, FCError>) -> ()

    private init() {}


    func insertItem(lat: Double, lon: Double, returnClosure: returnClosure? = nil) {
        let childUpdates = ["lat": lat, "lon": lon]

        ref.childByAutoId().updateChildValues(childUpdates)
    }
}
