//
//  LoginModels.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

enum Login {

    // MARK: - Use cases

    struct Request {
        enum RequestType {
            case generateModels
            case updateData(text: String, type: EquaTableTypes)
            case evaluateForm(models: [LoginViewModel])
        }

        let type: RequestType
    }

    struct Response {
        enum ResponseTypes {
            case textfield
            case button
        }
        var rawData: [ResponseTypes]
    }

    struct ResponseEvaluate {
        let username: String?
        let email: String?
        let password: String?
        let usernameError: String?
        let emailError: String?
        let passwordError: String?
    }

    struct ViewModel {
        var rawData: [LoginViewModel]
        var isFormValid: Bool
    }
}

enum EquaTableTypes {
    case username
    case email
    case password
    case submit
}

protocol LoginViewModel {
    var equaTableType: EquaTableTypes { get }
}

final class TextFieldModel: LoginViewModel {
    var equaTableType: EquaTableTypes
    let title: String
    let isSecured: Bool
    let placeholder: String
    let contentType: UITextContentType
    let keyboardType: UIKeyboardType
    let passwordRules: UITextInputPasswordRules?
    var errorText: String?
    var textFieldText: String?

    init(equaTableType: EquaTableTypes, title: String, isSecured: Bool, placeholder: String, contentType: UITextContentType, keyboardType: UIKeyboardType, passwordRules: UITextInputPasswordRules?, errorText: String?, textFieldText: String?) {
        self.equaTableType = equaTableType
        self.title = title
        self.isSecured = isSecured
        self.placeholder = placeholder
        self.contentType = contentType
        self.keyboardType = keyboardType
        self.passwordRules = passwordRules
        self.errorText = errorText
        self.textFieldText = textFieldText
    }
}

struct ButtonModel: LoginViewModel {
    var equaTableType: EquaTableTypes
    let title: String
}

final class LoginDataModel {
    var username: String?
    var email: String?
    var password: String?
}
