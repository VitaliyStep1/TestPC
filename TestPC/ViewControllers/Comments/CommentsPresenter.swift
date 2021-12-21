//
//  CommentsPresenter.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import Foundation

protocol CommentsPresenterVCInterface: NSObject {
    func reloadTableView()
    func showNavigationBarTitle(title: String)
    func showErrorAlert(message: String)
}

protocol CommentsPresenterInterface {
    func viewWillAppeared()
    func viewDidLoaded()
    func takeCellsAmount() -> Int
    func takeCellInfo(cellIndex: Int) -> (title: String, details: String)
    func setup(postId: Int)
}

class CommentsPresenter {
    weak var vc: CommentsPresenterVCInterface!
    lazy var serverManager = ServerManager.shared
    var selectedPostId: Int?
    
    var comments: [Comment]? {
        didSet {
            vc.reloadTableView()
            updateNavigationBarTitle()
        }
    }
    
    init(vc: CommentsPresenterVCInterface) {
        self.vc = vc
    }
}

extension CommentsPresenter: CommentsPresenterInterface {
    func viewDidLoaded() {

    }
    
    func viewWillAppeared() {
        updateNavigationBarTitle()
        vc.reloadTableView()
        loadCommentsFromServer()
    }
    
    func takeCellsAmount() -> Int {
        let cellsAmount = comments?.count ?? 0
        return cellsAmount
    }
    
    func takeCellInfo(cellIndex: Int) -> (title: String, details: String) {
        var title = ""
        var details = ""
        if comments?.count ?? 0 > cellIndex {
            let comment = comments![cellIndex]
            title = comment.email
            details = comment.body
        }
        return (title: title, details: details)
    }
    
    func setup(postId: Int) {
        self.selectedPostId = postId
    }
}

extension CommentsPresenter {
    func updateNavigationBarTitle() {
        var navigationBarTitle = "Comments"
        if let commentsAmount = comments?.count {
            navigationBarTitle += " (\(commentsAmount))"
        }
        vc.showNavigationBarTitle(title: navigationBarTitle)
    }
    
    func loadCommentsFromServer() {
        guard let postId = selectedPostId else {
            return
        }
        
        serverManager.loadCommentsForPost(postId: postId, completion: { [weak self] errorString, comments in
            self?.comments = comments
            if errorString != nil {
                let message = "Loading comments failed. " + errorString!
                self?.vc.showErrorAlert(message: message)
            }
        })
    }
}
