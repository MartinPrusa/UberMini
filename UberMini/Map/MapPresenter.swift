//
//  MapPresenter.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol MapPresentationLogic {
    func present(response: Map.Response)
}

final class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?

    // MARK: - PresentationLogic

    func present(response: Map.Response) {
        let viewModel = Map.ViewModel(username: response.username)
        viewController?.display(viewModel: viewModel)
    }
}
