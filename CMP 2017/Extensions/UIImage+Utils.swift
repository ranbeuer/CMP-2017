//
//  UIImage+Utilities.swift
//  USSteel
//
//  Created by Leonardo Cid on 10/8/17.
//

import UIKit

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x:0, y:size.height - 2*lineWidth, width:size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB(completionHandler:@escaping (UIImage?,NSData?)->()) -> Void {
        DispatchQueue.global().async { () -> Void in
            guard let imageData = UIImagePNGRepresentation(self) else {
                DispatchQueue.global().async { () -> Void in
                    completionHandler(nil, nil)
                }
                return
            }
            
            var resizingImage = self
            var imageSizeKB = Double(imageData.count) / 1024 // ! Or devide for 1024 if you need KB but not kB
            
            while imageSizeKB > 768 { // ! Or use 1024 if you need KB but not kB
                guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                    let imageData = UIImagePNGRepresentation(resizedImage)
                    else {
                        DispatchQueue.global().async { () -> Void in
                            completionHandler(nil, nil)
                        }
                        return
                    }
                
                resizingImage = resizedImage
                imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
            }
            let finalImageData = UIImagePNGRepresentation(resizingImage)
            DispatchQueue.main.async { () -> Void in
                completionHandler(resizingImage,finalImageData as! NSData)
            }
        }
        
    }
}
