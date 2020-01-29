//
//  MainViewModel.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelDelegate: class {
    func dataDidLoad(error: Error?)
}

class MainViewModel {
    private(set) var jogs = BehaviorRelay<[Jog]>(value: [])
    
    private let bag = DisposeBag()
    
    weak var delegate: MainViewModelDelegate?
    
    // MARK: Pablic functions
    func loadData() {
        NetworkService.shared.rxGetJog().observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] jogs in
                    self?.jogs.accept(jogs)
            },
                onError: { [weak self] error in
                    self?.delegate?.dataDidLoad(error: error)
            })
            .disposed(by: bag)
    }
    
    func getItemsCount() -> Int {
        return jogs.value.count
    }
    
    func getItem(for index: Int) -> Jog? {
        guard jogs.value.indices.contains(index) else { return nil }
        return   jogs.value[index]
    }
}
