//
//  UIImageCompression.swift
//  MyWallet
//
//  Created by John Xavier  on 17/08/2026.
//
import Foundation
import UIKit

extension UIImage {

    func resized(maxDimension: CGFloat) -> UIImage {
        let longest = max(size.width, size.height)
        guard longest > maxDimension else {
            return self
        }
        
        let scale = maxDimension / longest
        let target = CGSize(width: size.width * scale, height: size.height * scale)
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: target, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
    
    func jpegUnder(maxBytes: Int = 900_000, maxDimension: CGFloat = 1024) -> Data? {
        let image = resized(maxDimension: maxDimension)
        
        var quality: CGFloat = 0.8
        var data = image.jpegData(compressionQuality: quality)
        while let d = data, d.count > maxBytes, quality > 0.3 {
            quality -= 0.1
            data = image.jpegData(compressionQuality: quality)
        }
        
        return data
    }
    
  
}
