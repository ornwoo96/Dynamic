//
//  UIView+Color.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

extension UIView {
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.frame = self.bounds
        layer.addSublayer(gradient)
    }
    
    func setDiagonalGradient(_ color1: UIColor,
                     _ color2: UIColor,
                     _ color3: UIColor,
                     _ frame: CGSize) {
        let gradient = CAGradientLayer()
        gradient.frame.size = frame
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = [
            color1.cgColor,
            color2.cgColor,
            color3.cgColor
        ]
        layer.addSublayer(gradient)
    }
    
    func setGradientWithThreeColor(_ color1: UIColor,
                                   _ color2: UIColor,
                                   _ color3: UIColor,
                                   _ size: CGSize ) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.frame = CGRect(origin: .zero, size: size)
        
        layer.addSublayer(gradient)
    }
    
    func setCrossGradientWithThreeColor(_ color1: UIColor,
                               _ color2: UIColor,
                               _ color3: UIColor,
                               _ size: CGSize ) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(origin: .zero, size: size)

        layer.addSublayer(gradient)
    }
    
    func setAnimateGradientWithThreeColor(_ color1: UIColor,
                                          _ color2: UIColor,
                                          _ color3: UIColor,
                                          _ view: UIView) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.frame = view.bounds
        
        layer.addSublayer(gradient)
    }
}

extension UIColor {
    static var homeAlphaBlackColor1: UIColor {
        return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
    }
    
    static var homeAlphaBlackColor2: UIColor {
        return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    }
    
    static var heartViewBackgroundBlackColor: UIColor {
        return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
    }
    
    static var tabItemBlueRight: UIColor {
        return UIColor.init(red: 24/255, green: 193/255, blue: 253/255, alpha: 1)
    }
    
    static var tabItemBlueLeft: UIColor {
        return UIColor.init(red: 60/255, green: 93/255, blue: 253/255, alpha: 1)
    }
    
    static var tabItemRedRight: UIColor {
        return UIColor.init(red: 251/255, green: 76/255, blue: 89/255, alpha: 1)
    }
    
    static var tabItemRedMiddle: UIColor {
        return UIColor.init(red: 190/255, green: 47/255, blue: 175/255, alpha: 1)
    }
    
    static var tabItemRedLeft: UIColor {
        return UIColor.init(red: 132/255, green: 0, blue: 243/255, alpha: 1)
    }
    
    static var tabItemYellowRight: UIColor {
        return UIColor.init(red: 254/255, green: 224/255, blue: 78/255, alpha: 1)
    }
    
    static var tabItemYellowMiddle: UIColor {
        return UIColor.init(red: 253/255, green: 159/255, blue: 81/255, alpha: 1)
    }
    
    static var tabItemYellowLeft: UIColor {
        return UIColor.init(red: 251/255, green: 103/255, blue: 87/255, alpha: 1)
    }
    
    static var categoryBackgroundColor1: UIColor {
        return UIColor.init(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
    }
    
    static var categoryBackgroundColor2: UIColor {
        return UIColor.init(red: 19/255, green: 19/255, blue: 19/255, alpha: 1)
    }
    
    static var categoryBackgroundColor3: UIColor {
        return UIColor.init(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
    }
}
