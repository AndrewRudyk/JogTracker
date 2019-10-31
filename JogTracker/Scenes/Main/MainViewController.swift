//
//  MainViewController.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    static func create() -> MainViewController? {
        guard let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return nil }
        return mainViewController
    }
    
    
    @IBOutlet private weak var topBarView: TopBarView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let viewModel = MainViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        topBarView.delegate = self
        tableView.rowHeight = 188
        loadData()
    }
    
    
    // MARK: Actions
    @IBAction func addAction(_ sender: UIButton) {
        if let addViewController = AddJogViewController.create() {
            addViewController.delegate = self
            present(addViewController, animated: true)
        }
    }
    
    
    // MARK: Private functions
    private func loadData() {
        spinner.startAnimating()
        viewModel.loadData()
    }
}


// MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func dataDidLoad(error: Error?) {
        spinner.stopAnimating()
        guard error == nil else { print(error!); return }
        tableView.reloadData()
    }
}


// MARK: - AddJogViewControllerDelegate
extension MainViewController: AddJogViewControllerDelegate {
    func dataDidSave() {
        loadData()
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JogTableViewCell",
                                                       for: indexPath) as? JogTableViewCell,
            let item = viewModel.getItem(for: indexPath.row) else {
                return UITableViewCell()
        }
        
        cell.configure(for: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let jogModel = viewModel.getItem(for: indexPath.row)
        print("jogModel", jogModel?.id)
        if let addViewController = AddJogViewController.create(with: jogModel) {
            addViewController.delegate = self
            present(addViewController, animated: true)
        }
    }
}

// MARK: - TopBarViewDelegate
extension MainViewController: TopBarViewDelegate {
    func filterDidPushed(_ sender: TopBarView) {
    }
    
    func menuDidPushed(_ sender: TopBarView) {
        if let menuViewController = MenuViewController.create() {
            present(menuViewController, animated: true, completion: nil)
        }
    }
}
