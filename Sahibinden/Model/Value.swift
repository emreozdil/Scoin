//
//  Value.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import ObjectMapper

class Value: Mappable {
    var date: Double?
    var value: Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        date <- map["x"]
        value <- map["y"]
    }
}
