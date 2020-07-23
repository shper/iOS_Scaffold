//
//  UIImage+IconFont.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/6/8.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func iconFont(code: String,
                         size: CGFloat,
                         color: UIColor? = nil,
                         backgroundColor: UIColor = UIColor.clear) -> UIImage {
        
        var imageSize = CGSize(width: size, height: size)
        if imageSize.width <= 0 { imageSize.width = 1 }
        if imageSize.height <= 0 { imageSize.height = 1 }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        var attributes = [
            NSAttributedString.Key.font: UIFont.iconFont(ofSize: size)!,
            NSAttributedString.Key.backgroundColor: backgroundColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        if color != nil {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        
        let attributedString = NSAttributedString(string: code, attributes: attributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (imageSize.height - size) / 2, width: imageSize.width, height: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
