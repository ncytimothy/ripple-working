//
//  UIColor+Extensions.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let Divisor: CGFloat = 255
    
    static let primaryOrange: UIColor = UIColor.rgb(red: 245, green: 166, blue: 35)
    static let secondaryOrange: UIColor = UIColor.rgb(red: 239, green: 155, blue: 15)
    static let darkenOrange: UIColor = UIColor.rgb(red: 172, green: 113, blue: 14)
    static let overlayOrange: UIColor = UIColor.rgb(red: 217, green: 149, blue: 37, alpha: 0.68)
    static let customRed: UIColor = UIColor.rgb(red: 208, green: 2, blue: 27)
    static let signatureOrange: UIColor = UIColor.rgb(red: 247, green: 107, blue: 28)
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/Divisor, green: green/Divisor, blue: blue/Divisor, alpha: alpha)
    }
    
    
}
