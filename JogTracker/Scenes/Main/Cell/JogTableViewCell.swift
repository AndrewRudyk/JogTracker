//
//  JogTableViewCell.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class JogTableViewCell: UITableViewCell {
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var speedLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    
    func configure(for item: Jog) {
        dateLabel.text = formatDate(item.date)
        speedLabel.text = String(format: "%.0f", item.speed)
        distanceLabel.text = String(format: "%.0f", item.distance)
        timeLabel.text = String(format: "%.0f", item.time)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formatDate = dateFormatter.string(from: date)
        return formatDate
    }
}
