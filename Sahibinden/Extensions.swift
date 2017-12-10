//
//  Extensions.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r:CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static var sahibinden = UIColor(r: 254, g: 230, b: 51)
    static var background = UIColor(r: 230, g: 230, b: 230)
}
