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
    
    func setGradientWithArrayThreeColor(_ cgcolors: [CGColor], _ size: CGSize) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = cgcolors
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
    
    func setCrossGradientWithThreeColorAndReturnLayer(_ colors: [UIColor],
                                                      _ size: CGSize) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [colors[0].cgColor, colors[1].cgColor, colors[2].cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(origin: .zero, size: size)
        
        layer.addSublayer(gradient)
        return gradient
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
    
    static var buttonHighlightColor: UIColor {
        return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    }
    
}

// MARK: Gradient 3Colors
extension UIColor {
    static var gradientSeries1: [CGColor] {
        return [UIColor.systemRed.cgColor, UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
    }
    
    static var gradientSeries2: [CGColor] {
        return [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor, UIColor.systemTeal.cgColor]
    }
    
    static var gradientSeries3: [CGColor] {
        return [UIColor.systemMint.cgColor, UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
    }
    
    static var gradientSeries4: [CGColor] {
        return [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
    }
    
    static var gradientSeries5: [CGColor] {
        return [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor, UIColor.systemRed.cgColor]
    }
    
    static var gradientSeries6: [CGColor] {
        return [UIColor.systemCyan.cgColor, UIColor.systemYellow.cgColor, UIColor.systemRed.cgColor]
    }
    
    static var gradientSeries7: [CGColor] {
        return [UIColor.systemTeal.cgColor, UIColor.systemYellow.cgColor, UIColor.systemPurple.cgColor]
    }
    
    static var gradientSeries8: [CGColor] {
        return [UIColor.systemPink.cgColor, UIColor.systemYellow.cgColor, UIColor.systemBlue.cgColor]
    }
    
    static var gradientSeries9: [CGColor] {
        return [UIColor.systemRed.cgColor,
                UIColor.systemPink.cgColor,
                UIColor.systemPurple.cgColor,
                UIColor.systemBlue.cgColor]
    }
    
    static var gradientSeries10: [CGColor] {
        return [UIColor.systemRed.cgColor,
                UIColor.systemPink.cgColor,
                UIColor.systemPurple.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.systemTeal.cgColor,
                UIColor.systemMint.cgColor]
    }
    
    static var gradientSeries11: [CGColor] {
        return [UIColor.systemMint.cgColor,
                UIColor.systemTeal.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.systemPurple.cgColor,
                UIColor.systemPink.cgColor,
                UIColor.systemRed.cgColor]
    }
}

extension UIColor {
    static var randomGradientSeries: [CGColor] {
        let array: [[CGColor]] = [UIColor.gradientSeries1,
                                  UIColor.gradientSeries2,
                                  UIColor.gradientSeries3,
                                  UIColor.gradientSeries4,
                                  UIColor.gradientSeries5,
                                  UIColor.gradientSeries6,
                                  UIColor.gradientSeries7,
                                  UIColor.gradientSeries8]
        let randomNumber = ((0..<8).randomElement()) ?? 0
        
        return array[randomNumber]
    }
    
    static func branchGradient(number: Int) -> [CGColor] {
        switch number {
        case 0:
            return UIColor.gradientSeries1
        case 1:
            return UIColor.gradientSeries2
        case 2:
            return UIColor.gradientSeries3
        case 3:
            return UIColor.gradientSeries4
        case 4:
            return UIColor.gradientSeries5
        case 5:
            return UIColor.gradientSeries6
        case 6:
            return UIColor.gradientSeries7
        case 7:
            return UIColor.gradientSeries8
        default:
            return UIColor.gradientSeries1
        }
    }
}

// MARK: Dynamic 8colors
extension UIColor {
    static var dynamicRed: UIColor {
        return UIColor.init(red: 183/255, green: 28/255, blue: 67/255, alpha: 1)
    }
    
    static var dynamicTurquoise: UIColor {
        return UIColor.init(red: 35/255, green: 136/255, blue: 165/255, alpha: 1)
    }
    
    static var dynamicPink: UIColor {
        return UIColor.init(red: 200/255, green: 95/255, blue: 133/255, alpha: 1)
    }
    
    static var dynamicGreen: UIColor {
        return UIColor.init(red: 105/255, green: 149/255, blue: 107/255, alpha: 1)
    }
    
    static var dynamicPurple: UIColor {
        return UIColor.init(red: 121/255, green: 79/255, blue: 130/255, alpha: 1)
    }
    
    static var dynamicOrange: UIColor {
        return UIColor.init(red: 185/255, green: 66/255, blue: 29/255, alpha: 1)
    }
    
    static var dynamicTeal: UIColor {
        return UIColor.init(red: 45/255, green: 138/255, blue: 123/255, alpha: 1)
    }
    
    static var dynamicYellow: UIColor {
        return UIColor.init(red: 212/255, green: 140/255, blue: 42/255, alpha: 1)
    }
}
