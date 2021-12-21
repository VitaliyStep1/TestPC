//
//  UsersPresenter.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation

protocol UsersPresenterVCInterface: NSObject {
    func reloadTableView()
    func showNavigationBarTitle(title: String)
    func showErrorAlert(message: String)
    func userWasSelected(user: User)
    func popVC()
}

protocol UsersPresenterInterface {
    func viewDidLoaded()
    func viewWillAppeared()
    func takeCellsAmount() -> Int
    func takeCellInfo(cellIndex: Int) -> String
    func setup(selectedUserId: Int, users: [User]?)
    func cellWasSelected(cellIndex: Int)
}

class UsersPresenter {
    weak var vc: UsersPresenterVCInterface!
    lazy var serverManager = ServerManager.shared
    var selectedUserId: Int?
    var isViewDidLoaded = false
    var users: [User]? {
        didSet {
            if isViewDidLoaded {
                vc?.reloadTableView()
                updateNavigationBarTitle()
            }
        }
    }
    
    init(vc: UsersPresenterVCInterface) {
        self.vc = vc
    }
}

extension UsersPresenter: UsersPresenterInterface {
    func viewDidLoaded() {
        isViewDidLoaded = true
    }
    
    func viewWillAppeared() {
        vc.reloadTableView()
        updateNavigationBarTitle()
        if users == nil {
            loadUsersFromServer()
        }
    }
    
    func takeCellsAmount() -> Int {
        let cellsAmount = users?.count ?? 0
        return cellsAmount
    }
    
    func takeCellInfo(cellIndex: Int) -> String {
        var title = ""
        if users?.count ?? 0 > cellIndex {
            let user = users![cellIndex]
            title = user.name
        }
        return title
    }
    
    func setup(selectedUserId: Int, users: [User]?) {
        self.selectedUserId = selectedUserId
        self.users = users
    }
    
    func cellWasSelected(cellIndex: Int) {
        if users?.count ?? 0 > cellIndex {
            let user = users![cellIndex]
            vc.userWasSelected(user: user)
        }
        vc.popVC()
    }
}

extension UsersPresenter {
    func loadUsersFromServer() {
        serverManager.loadUsers { [weak self] errorString, users in
            self?.users = users
            if errorString != nil {
                let message = "Loading users failed. " + errorString!
                self?.vc.showErrorAlert(message: message)
            }
        }
    }
    
    func updateNavigationBarTitle() {
        var navigationBarTitle = ""
        if let userId = selectedUserId {
            if let selectedUser = users?.first(where: {$0.id == userId}) {
                navigationBarTitle = selectedUser.name
            }
        }
        vc.showNavigationBarTitle(title: navigationBarTitle)
    }
}
