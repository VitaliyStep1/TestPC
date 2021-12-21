//
//  PostsPresenter.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation

protocol PostsPresenterVCInterface: NSObject {
    func reloadTableView()
    func showNavigationBarTitle(title: String)
    func showErrorAlert(message: String)
    func showCommentsVC(postId: Int)
    func addUserItemToNavigationBar()
    func showUsersVC(selectedUserId: Int, users: [User]?)
    func setupViews()
}

protocol PostsPresenterInterface {
    func viewDidLoaded()
    func viewWillAppeared()
    func takeCellsAmount() -> Int
    func takeCellInfo(cellIndex: Int) -> (title: String, details: String)
    func cellWasSelected(cellIndex: Int)
    func userButtonClicked()
    func userWasSelected(user: User)
}

class PostsPresenter {
    weak var vc: PostsPresenterVCInterface!
    lazy var serverManager = ServerManager.shared
    var selectedUserId = 1
    var users: [User]?
    var posts: [Post]? {
        didSet {
            vc?.reloadTableView()
        }
    }
    var user: User? {
        didSet {
            let title = user?.name ?? ""
            vc?.showNavigationBarTitle(title: title)
        }
    }
    
    init(vc: PostsPresenterVCInterface) {
        self.vc = vc
    }
}

extension PostsPresenter: PostsPresenterInterface {
    func viewDidLoaded() {
        self.user = nil
        vc.addUserItemToNavigationBar()
        vc.setupViews()
    }
    
    func viewWillAppeared() {
        vc.reloadTableView()
        loadUsersFromServer()
        loadPostsFromServer()
    }
    
    func takeCellsAmount() -> Int {
        let cellsAmount = posts?.count ?? 0
        return cellsAmount
    }
    
    func takeCellInfo(cellIndex: Int) -> (title: String, details: String) {
        var title = ""
        var details = ""
        if posts?.count ?? 0 > cellIndex {
            let post = posts![cellIndex]
            title = post.title
            details = post.body
        }
        return (title: title, details: details)
    }
    
    func cellWasSelected(cellIndex: Int) {
        if posts?.count ?? 0 > cellIndex {
            let post = posts![cellIndex]
            let postId = post.id
            vc.showCommentsVC(postId: postId)
        }
        else {
            let message = "Necessary post was not found"
            vc.showErrorAlert(message: message)
        }
    }
    
    func userButtonClicked() {
        vc.showUsersVC(selectedUserId: selectedUserId, users: users)
    }
    
    func userWasSelected(user: User) {
        selectedUserId = user.id
        self.user = user
    }
}

extension PostsPresenter {
    func loadUsersFromServer() {
        serverManager.loadUsers { [weak self] errorString, users in
            if let self = self {
                let userId = self.selectedUserId
                let selectedUser = users?.first(where: {$0.id == userId})
                self.user = selectedUser
                self.users = users
            }
            if errorString != nil {
                let message = "Loading users failed. " + errorString!
                self?.vc.showErrorAlert(message: message)
            }
        }
    }
    
    func loadPostsFromServer() {
        let userId = selectedUserId
        serverManager.loadPostsForUser(userId: userId) { [weak self] errorString, posts in
            self?.posts = posts
            if errorString != nil {
                let message = "Loading posts failed. " + errorString!
                self?.vc.showErrorAlert(message: message)
            }
        }
    }
}
