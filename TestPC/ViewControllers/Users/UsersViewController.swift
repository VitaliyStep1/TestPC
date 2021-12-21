//
//  UsersViewController.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import UIKit

protocol UserSelectionDelegate: NSObject {
    func userWasSelected(user: User)
}

class UsersViewController: BaseViewController {
    lazy var presenter: UsersPresenterInterface = UsersPresenter(vc: self)
    @IBOutlet weak var tableView: UITableView!
    weak var userSelectionDelegate: UserSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppeared()
    }
    
    func setup(selectedUserId: Int, users: [User]?, delegate: UserSelectionDelegate) {
        self.userSelectionDelegate = delegate
        presenter.setup(selectedUserId: selectedUserId, users: users)
    }
}

extension UsersViewController: UsersPresenterVCInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showNavigationBarTitle(title: String) {
        self.title = title
    }
    
    func userWasSelected(user: User) {
        userSelectionDelegate?.userWasSelected(user: user)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsAmount = presenter.takeCellsAmount()
        return cellsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UsersCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UsersTableViewCell
        let title = presenter.takeCellInfo(cellIndex: indexPath.row)
        cell.titleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellWasSelected(cellIndex: indexPath.row)
    }
}
