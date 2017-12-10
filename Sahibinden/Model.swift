//
//  Model.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import ObjectMapper


class Ticker: Mappable {
    var date: Double?
    var value: Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        value <- map["value"]
    }
}

class Bitcoin: Mappable {
    var description: String?
    var name: String?
    var period: String?
    var status: String?
    var unit: String?
    var values: [Value]?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        description <- map["description"]
        name <- map["name"]
        period <- map["period"]
        status <- map["status"]
        unit <- map["unit"]
        values <- map["values"]
    }
}

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
