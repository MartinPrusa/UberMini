//
//  LoginWorker.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

final class LoginWorker {
    func generateModels() -> Login.Response {
        .init(rawData: [.textfield, .button])
    }

    func evaluateForm(dataModel: LoginDataModel) -> Login.ResponseEvaluate {
        let usernameError = (dataModel.username?.isEmpty == true || dataModel.username == nil) ? "Invalid username" : nil
        let emailError = dataModel.email?.isValidEmail == true ? nil : "Invalid e-mail address"
        let passwordError = dataModel.password?.isValidPassword == true ? nil : "At least one uppercase, one digit, one lowercase, 8 characters minimum"

        let response = Login.ResponseEvaluate(username: dataModel.username, email: dataModel.email, password: dataModel.password, usernameError: usernameError, emailError: emailError, passwordError: passwordError)
        return response
    }
}
