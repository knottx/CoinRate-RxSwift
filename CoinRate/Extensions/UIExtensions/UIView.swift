//
//  UIView.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import UIKit

extension UIView {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
    class func loadFromNib<T:UIView>(of type: T.Type) -> T {
        return UINib.init(nibName: self.identifier(), bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
    
    func setCornerRadius(_ value:CGFloat, masksToBounds:Bool = true) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = masksToBounds
    }
    
    func setCircle() {
        self.setCornerRadius(self.frame.height / 2)
    }
    
    func setBorder(width:CGFloat, color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
