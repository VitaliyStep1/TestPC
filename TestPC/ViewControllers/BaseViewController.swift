//
//  BaseViewController.swift
//  TestPC
//
//  Created by Vitaliy Stepanenko on 21.12.2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundColorName = "BackgroundFullScreen"
        view.backgroundColor = UIColor(named: backgroundColorName)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
