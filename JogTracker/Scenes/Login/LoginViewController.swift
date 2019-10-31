//
//  LoginViewController.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        topBarView.set(showingStyle: .filterIsHidden)
        topBarView.delegate = self
    }

    
    // MARK: Actions
    @IBAction func loginAction(_ sender: UIButton) {
        spinner.startAnimating()
        NetworkService.shared.logIn { [weak self] result in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                switch result {
                case .success(_):
                    if let mainViewController = MainViewController.create() {
                        self?.navigationController?.pushViewController(mainViewController, animated: true)
                    }
                case .failure(let error):
                    print(error)
                    self?.showAlert(withTitle: "Error", message: "No auth", buttonTitle: "OK")
                }
            }
        }
    }
    
    
    // MARK: Private functions
    private func setupUI() {
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor(named: "appPink")?.cgColor
        loginButton.layer.cornerRadius = 30
    }
}


// MARK: - TopBarViewDelegate
extension LoginViewController: TopBarViewDelegate {
    func filterDidPushed(_ sender: TopBarView) {
    }
    
    func menuDidPushed(_ sender: TopBarView) {
        if let menuViewController = MenuViewController.create() {
            present(menuViewController, animated: true, completion: nil)
        }
    }
}
