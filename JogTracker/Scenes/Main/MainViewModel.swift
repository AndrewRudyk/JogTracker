//
//  MainViewModel.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func dataDidLoad(error: Error?)
}

class MainViewModel {
    
    private var jogs: [Jog] = []
    
    weak var delegate: MainViewModelDelegate?
    
    // MARK: Pablic functions
    func loadData() {
        NetworkService.shared.getJogs { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let jogs):
                    self?.jogs = jogs
                    self?.delegate?.dataDidLoad(error: nil)
                case .failure(let error):
                    self?.delegate?.dataDidLoad(error: error)
                }
            }
        }
    }
    
    func getItemsCount() -> Int {
        return jogs.count
    }
    
    func getItem(for index: Int) -> Jog? {
        guard jogs.indices.contains(index) else { return nil }
        return jogs[index]
    }
}
