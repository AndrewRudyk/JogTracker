//
//  Parser.swift
//  JogTracker
//
//  Created by Prostor9 on 10/30/19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation

class Parser {
    
    static func parseToken(_ data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = jsonDict["response"] as? [String: Any],
            let token = response["access_token"] as? String
            else { return nil }
        
        return token
    }
    
    static func parseJogs(_ data: Data) -> [Jog]? {
        guard let tempObject = try? JSONDecoder().decode(JogsTempModel.self, from: data) else { return nil }
        return tempObject.jogs
    }
    
}
