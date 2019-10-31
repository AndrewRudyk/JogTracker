//
//  TopBarView.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

protocol TopBarViewDelegate: class {
    func filterDidPushed(_ sender: TopBarView)
    func menuDidPushed(_ sender: TopBarView)
}

class TopBarView: UIView {
    enum ShowingStyle {
        case filterIsHidden
        case menu
    }
    
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var menuButton: UIButton!
    @IBOutlet private weak var bearIconImageView: UIImageView!
    @IBOutlet private weak var logoLabel: UILabel!
    
    weak var delegate: TopBarViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    
    // MARK: Actions
    @IBAction func filterAction(_ sender: UIButton) {
        self.delegate?.filterDidPushed(self)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.delegate?.menuDidPushed(self)
    }
    
    
    // MARK: Public functions
    func set(showingStyle: ShowingStyle) {
        switch showingStyle {
        case .filterIsHidden:
            filterButton.isHidden = true
        case .menu:
            filterButton.isHidden = true
            let closeImage = UIImage(named: "closeButtonIcon")
            menuButton.setImage(closeImage, for: .normal)
            menuButton.tintColor = UIColor.lightGray
            self.subviews.first?.backgroundColor = .white
            bearIconImageView.tintColor = UIColor(named: "appGreen")
            logoLabel.textColor = UIColor(named: "appGreen") ?? .black
        }
    }
    
    
    // MARK: Private functions
    private func setupView() {
        if let contentView = UINib(nibName: "TopBarView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(contentView)
            contentView.pinToSuperviewEdges()
        }
    }

}
