//
//  MenuViewController.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    static func create() -> MenuViewController? {
        guard let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return nil }
        return menuViewController
    }
    
    
    @IBOutlet private weak var topBarView: TopBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarView.set(showingStyle: .menu)
        topBarView.delegate = self
    }

}


// MARK: - TopBarViewDelegate
extension MenuViewController: TopBarViewDelegate {
    func filterDidPushed(_ sender: TopBarView) {
    }
    
    func menuDidPushed(_ sender: TopBarView) {
        dismiss(animated: true, completion: nil)
    }
}
