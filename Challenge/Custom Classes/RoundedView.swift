//
//  RoundedView.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var backgroundColos: UIColor? = UIColor.clear
    @IBInspectable var borderColor: UIColor? = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var isRounded: Bool = false
    @IBInspectable var isTopRadius: Bool = false
    @IBInspectable var isBottomRadius: Bool = false
    @IBInspectable var isBottomLeftRadius: Bool = false
    @IBInspectable var isBottomRightRadius: Bool = false
    @IBInspectable var isTopLeftRadius: Bool = false
    @IBInspectable var isTopRightRadius: Bool = false

    override func layoutSubviews() {
        
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        
        if(isRounded){
            layer.cornerRadius = layer.frame.height / 2
        }
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        if(isBottomRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        if(isBottomLeftRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        if(isTopRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        if(isBottomRightRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [ .bottomRight ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        if(isTopRightRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        if(isTopLeftRadius){
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [ .topLeft ], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.mask = rectShape
        }
        
        layer.backgroundColor = backgroundColos?.cgColor
    }
}
