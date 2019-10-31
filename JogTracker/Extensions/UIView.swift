//
//  UIView.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToSuperviewEdges() {
        guard let superview = self.superview else { return }
        
        let topConstraint = NSLayoutConstraint(item: self,
                                               attribute: .topMargin,
                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                               toItem: superview,
                                               attribute: .topMargin,
                                               multiplier: 1,
                                               constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .bottomMargin,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: superview,
                                                  attribute: .bottomMargin,
                                                  multiplier: 1,
                                                  constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .leadingMargin,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: superview,
                                                   attribute: .leadingMargin,
                                                   multiplier: 1,
                                                   constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailingMargin,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: superview,
                                                    attribute: .trailingMargin,
                                                    multiplier: 1,
                                                    constant: 0)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}
