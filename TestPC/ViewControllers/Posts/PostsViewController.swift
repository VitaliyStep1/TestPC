//
//  PostsViewController.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import UIKit

class PostsViewController: BaseViewController {
    lazy var presenter: PostsPresenterInterface = PostsPresenter(vc: self)
    @IBOutlet weak var tableView: UITableView!
    let commentsVCIdentifier = "ShowCommentsVCIdentifier"
    let showUsersVCIdentifier = "ShowUsersVCIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppeared()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentsVCIdentifier {
            if let postId = sender as? Int {
                let vc = segue.destination as! CommentsViewController
                vc.setupSelectedPost(postId: postId)
            }
        }
        else if segue.identifier == showUsersVCIdentifier {
            let vc = segue.destination as! UsersViewController
            let userInfo = sender as! (selectedUserId: Int, users: [User]?)
            let selectedUserId = userInfo.selectedUserId
            let users = userInfo.users
            vc.setup(selectedUserId: selectedUserId, users: users, delegate: self)
        }
    }
    
    @objc func userButtonClick() {
        presenter.userButtonClicked()
    }
}

extension PostsViewController: PostsPresenterVCInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showNavigationBarTitle(title: String) {
        self.title = title
    }
    
    func showCommentsVC(postId: Int) {
        performSegue(withIdentifier: commentsVCIdentifier, sender: postId)
    }
    
    func addUserItemToNavigationBar() {
        let userButton = UIButton()
        let userImage = UIImage(named: "Users_userIcon")
        userButton.setImage(userImage, for: .normal)
        userButton.addTarget(self, action: #selector(userButtonClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userButton)
    }
    
    func showUsersVC(selectedUserId: Int, users: [User]?) {
        performSegue(withIdentifier: showUsersVCIdentifier, sender: (selectedUserId: selectedUserId, users: users))
    }
    
    func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsAmount = presenter.takeCellsAmount()
        return cellsAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PostsCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostsTableViewCell
        let cellInfo = presenter.takeCellInfo(cellIndex: indexPath.row)
        cell.titleLabel.text = cellInfo.title
        cell.detailsLabel.text = cellInfo.details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellWasSelected(cellIndex: indexPath.row)
    }
}

extension PostsViewController: UserSelectionDelegate {
    func userWasSelected(user: User) {
        presenter.userWasSelected(user: user)
    }
}
