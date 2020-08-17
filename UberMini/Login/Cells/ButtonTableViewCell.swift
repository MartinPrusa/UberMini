//
//  ButtonTableViewCell.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//

import UIKit

protocol ButtonCellDelegate: AnyObject {
    func buttonTapped()
}

final class ButtonTableViewCell: UITableViewCell {

    private var submitButton = UIButton(type: .custom)
    private let padding: CGFloat = 8.0
    private let height: CGFloat = 44

    private weak var delegate: ButtonCellDelegate?

    func setup(with model: ButtonModel, delegate: ButtonCellDelegate? = nil) {
        selectionStyle = .none
        layout()
        
        submitButton.setTitle(model.title, for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.delegate = delegate
    }

    @objc func buttonTapped() {
        delegate?.buttonTapped()
    }

    private func layout() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })

        //submit button label
        contentView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: submitButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: padding)
        let right = NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -padding)
        let top = NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: padding)
        let bottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: submitButton, attribute: .bottom, multiplier: 1.0, constant: padding)

        let height = NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.height)

        contentView.addConstraints([top, left, bottom, right, height])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
}
