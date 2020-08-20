//
//  LoginInteractor.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol LoginBusinessLogic: AnyObject {
    func process(request: Login.Request)
}

protocol LoginDataStore: AnyObject {
    var username: String { get }
}

final class LoginInteractor: LoginBusinessLogic, LoginDataStore {

    var presenter: LoginPresentationLogic!
    var worker: LoginWorker!
    var username: String {
        return dataModel.username ?? "Unknown username"
    }

    private var dataModel = LoginDataModel()

    // MARK: - BusinessLogic

    func process(request: Login.Request) {
        switch request.type {
            case .generateModels:
                generateModels()
            case .updateData(let text, let type):
                updateData(text: text, type: type)
            case .evaluateForm(let models):
                evaluateForm(models: models)
        }
    }

    private func generateModels() {
        let response = worker.generateModels()
        presenter.present(response: response)
    }

    private func updateData(text: String, type: EquaTableTypes) {
        switch type {
            case .email:
                dataModel.email = text
            case .username:
                dataModel.username = text
            case .password:
                dataModel.password = text
            default:
                break
        }
    }

    private func evaluateForm(models: [LoginViewModel]) {
        let response = worker.fakeEvaluateForm(dataModel: dataModel)
        presenter.present(response: response, viewModels: models)
    }
}
