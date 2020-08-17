//
//  LoginViewController.swift
//  UberMini
//
//  Created by Martin Prusa on 16.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol LoginDisplayLogic: AnyObject {
    func display(viewModel: Login.ViewModel, buttonTapped: Bool)
}

final class LoginViewController: UITableViewController, LoginDisplayLogic {

    var interactor: LoginBusinessLogic!
    var router: (LoginRoutingLogic & LoginDataPassing)!

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupCleanSwift()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCleanSwift()
    }

    override init(style: UITableView.Style) {
        super.init(style: style)
        setupCleanSwift()
    }

    private var viewModels: [LoginViewModel]?

    // MARK: - Setup

    private func setupCleanSwift() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        let worker = LoginWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        registerCells()
        generateModels()
    }

    private func registerCells() {
        tableView.register(TextFieldTableCell.self, forCellReuseIdentifier: String(describing: TextFieldTableCell.self))
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: String(describing: ButtonTableViewCell.self))
    }

    // MARK: - BusinessLogic

    func generateModels() {
        interactor.process(request: .init(type: .generateModels))
    }

    // MARK: - DisplayLogic

    func display(viewModel: Login.ViewModel, buttonTapped: Bool) {
        viewModels = viewModel.rawData
        tableView.reloadData()

        if buttonTapped == true && viewModel.isFormValid == true {
            router.navigateToMap()
        }
    }

    //username, email, pwd, submit
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        switch viewModels?[indexPath.row].equaTableType {
            case .email, .password, .username:
                guard let model = viewModels?[indexPath.row] as? TextFieldModel else { return defaultCell }
                let cell = dequeueReusableCell(fromClass: TextFieldTableCell.self, for: indexPath)
                cell.setup(with: model)
                cell.delegate = self
                return cell
            case .submit:
                guard let model = viewModels?[indexPath.row] as? ButtonModel else { return defaultCell }
                let cell = dequeueReusableCell(fromClass: ButtonTableViewCell.self, for: indexPath)
                cell.setup(with: model, delegate: self)
                return cell
            case .none:
                break
        }
        return defaultCell
    }

    func dequeueReusableCell<T: UITableViewCell>(fromClass type: T.Type, for indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
}

extension LoginViewController: ButtonCellDelegate {
    func buttonTapped() {
        guard let models = viewModels else { return }
        interactor.process(request: .init(type: .evaluateForm(models: models)))
    }
}

extension LoginViewController: TextFieldTableCellDelegate {
    func textFieldDidChange(text: String, type: EquaTableTypes) {
        interactor.process(request: .init(type: .updateData(text: text, type: type)))
    }
}
