//
//  LoginPresenter.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol LoginPresentationLogic: AnyObject {
    func present(response: Login.Response)
    func present(response: Login.ResponseEvaluate, viewModels: [LoginViewModel])
}

final class LoginPresenter: LoginPresentationLogic {

    weak var viewController: LoginDisplayLogic?

    // MARK: - PresentationLogic

    func present(response: Login.Response) {
        var models = [LoginViewModel]()
        response.rawData.forEach { type in
            switch type {
                case .textfield:
                    let username = TextFieldModel(equaTableType: .username, title: "Username:", isSecured: false, placeholder: "Enter username", contentType: .username, keyboardType: .namePhonePad, passwordRules: nil, errorText: nil, textFieldText: nil)
                    let email = TextFieldModel(equaTableType: .email, title: "E-mail:", isSecured: false, placeholder: "Enter e-mail", contentType: .emailAddress, keyboardType: .emailAddress, passwordRules: nil, errorText: nil, textFieldText: nil)

                    let pwdRules = UITextInputPasswordRules(descriptor: "required: lower; required: upper; required: digit; required: [-]; minlength: 20;")
                    let password = TextFieldModel(equaTableType: .password, title: "Password:", isSecured: true, placeholder: "Enter password", contentType: .newPassword, keyboardType: .default, passwordRules: pwdRules, errorText: nil, textFieldText: nil)
                    models.append(contentsOf: [username, email, password])
                case .button:
                    let submit = ButtonModel.init(equaTableType: .submit, title: "Submit")
                    models.append(submit)
            }
        }

        viewController?.display(viewModel: .init(rawData: models, isFormValid: true), buttonTapped: false)
    }

    func present(response: Login.ResponseEvaluate, viewModels: [LoginViewModel]) {
        viewModels.forEach { model in
            if let viewModel = model as? TextFieldModel {
                switch model.equaTableType {
                    case .email:
                        viewModel.errorText = response.emailError
                        viewModel.textFieldText = response.email
                    case .password:
                        viewModel.errorText = response.passwordError
                        viewModel.textFieldText = response.password
                    case .username:
                        viewModel.errorText = response.usernameError
                        viewModel.textFieldText = response.username
                    default:
                        break
                }
            }
        }

        let isValid = response.emailError == nil && response.passwordError == nil && response.usernameError == nil
        viewController?.display(viewModel: .init(rawData: viewModels, isFormValid: isValid), buttonTapped: true)
    }
}
