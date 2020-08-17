//
//  TextFieldTableCell.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//

import UIKit

protocol TextFieldTableCellDelegate: AnyObject {
    func textFieldDidChange(text: String, type: EquaTableTypes)
}

final class TextFieldTableCell: UITableViewCell {

    private var titleLabel = UILabel()
    private var textField = UITextField()
    private var errorLabel = UILabel()

    private let padding: CGFloat = 18.0
    private var textFieldModel: TextFieldModel!

    weak var delegate: TextFieldTableCellDelegate?

    func setup(with model: TextFieldModel) {
        selectionStyle = .none
        textFieldModel = model
        layout()

        titleLabel.text = model.title

        textField.placeholder = model.placeholder
        textField.isSecureTextEntry = model.isSecured
        textField.borderStyle = .none
        textField.keyboardType = model.keyboardType
        textField.textContentType = model.contentType
        textField.passwordRules = model.passwordRules
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.text = model.textFieldText

        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.text = model.errorText
    }

    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.textFieldDidChange(text: text, type: textFieldModel.equaTableType)
    }

    private func layout() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })

        //title label
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftTitle = NSLayoutConstraint.init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: padding)
        let rightTitle = NSLayoutConstraint.init(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -padding)
        let topTitle = NSLayoutConstraint.init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: padding)

        //textfield label
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        let bottomTitle = NSLayoutConstraint.init(item: textField, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: padding)

        let leftTextField = NSLayoutConstraint.init(item: textField, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: padding)
        let rightTextField = NSLayoutConstraint.init(item: textField, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -padding)

        //error label
        contentView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        let bottomTextField = NSLayoutConstraint.init(item: textField, attribute: .bottom, relatedBy: .equal, toItem: errorLabel, attribute: .top, multiplier: 1.0, constant: -padding)

        let leftError = NSLayoutConstraint.init(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: padding)
        let rightError = NSLayoutConstraint.init(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -padding)

        let bottomError = NSLayoutConstraint.init(item: errorLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -padding)

        contentView.addConstraints([topTitle, leftTitle, bottomTitle, rightTitle, leftTextField, rightTextField, bottomTextField, leftError, rightError, bottomError])
    }
}
