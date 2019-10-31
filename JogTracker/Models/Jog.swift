//
//  Jog.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation

struct Jog: Codable {
    let id: Int
    let jogId: Int?
    let userId: String
    let date: Date
    let distance: Float     // km
    let time: Float         // min
    var speed: Float {
        get {
            return distance / (time / 60)
        }
    }
    
    init(id: Int = 0, userId: String = "", date: Date, distance: Float, time: Float) {
        self.id = id
        self.jogId = id
        self.userId = userId
        self.date = date
        self.distance = distance
        self.time = time
    }
    
}

extension Jog {
    enum CodingKeys: String, CodingKey {
        case id
        case jogId = "jog_id"
        case userId = "user_id"
        case distance
        case time
        case date
    }
    
}


struct JogsTempModel: Decodable {
    let jogs: [Jog]
    
    enum TopCodingKeys:  CodingKey {
        case response
        case jogs
    }
    
    init(jogs: [Jog]) {
        self.jogs = jogs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopCodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: TopCodingKeys.self, forKey: .response)
        let jogs = try nestedContainer.decode([Jog].self, forKey: .jogs)

        self.init(jogs: jogs)
    }
}
