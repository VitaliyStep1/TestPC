//
//  CommentsViewController.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import UIKit

class CommentsViewController: BaseViewController {
    lazy var presenter: CommentsPresenterInterface = CommentsPresenter(vc: self)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppeared()
    }
    
    func setupSelectedPost(postId: Int) {
        presenter.setup(postId: postId)
    }
}

extension CommentsViewController: CommentsPresenterVCInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showNavigationBarTitle(title: String) {
        self.title = title
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsAmount = presenter.takeCellsAmount()
        return cellsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommentsCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentsTableViewCell
        let cellInfo = presenter.takeCellInfo(cellIndex: indexPath.row)
        cell.titleLabel.text = cellInfo.title
        cell.detailsLabel.text = cellInfo.details
        return cell
    }
}
