//
//  UITextField+DynamicFontSize.swift
//  VCCapture
//
//  Created by Vincent on 2019/10/31.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Foundation

private let kMaxFontSize = 100
private let kMinFontSize = 5

private let kPaddingWidth: CGFloat  = 24
private let kPaddingHeight: CGFloat = 10

private let kMinTFWidth: CGFloat  = 20

class VCStickerUtils {
    
    /// 获取两点的直线距离
    class func getDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let diffX = point2.x - point1.x
        let diffY = point2.y - point1.y
        
        return sqrt(diffX * diffX + diffY * diffY)
    }
}

extension UIColor {
    func highlightColor() -> UIColor {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        
        return white > 0.5 ? .black : .white
    }
}

extension UITextField {
    
    /// 调整文字大小适应新的边框
    func adjustsFontSizeToFillRect(_ dstRect: CGRect) {
        
        let text = getCurrentText()
       
        guard !text.isEmpty else {
            return
        }
        
        // 遍历，寻找最适合的文字大小
        for size in (kMinFontSize...kMaxFontSize).reversed() {
            // 获取当前字体
            let font = self.font!.withSize(CGFloat(size))
            
            let attrText = NSAttributedString(string: text, attributes: [.font: font])
            
            // 使用目标宽度计算大小
            let rectSize = attrText.boundingRect(with: CGSize(width: dstRect.width - kPaddingWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], context: nil)
            
            // 当所需高度小于目标高度时结束遍历，设置字体
            if rectSize.height < dstRect.height {
                self.font = font
                break
            }
        }
    }
    
    /// 调整当前frame适应内容
    func adjustsWidthToFillContents() -> CGRect {
        let text = getCurrentText()
        
        let attrText = NSAttributedString(string: text, attributes: [.font: self.font!])
        var rectSize = attrText.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: self.frame.height), options: [.usesLineFragmentOrigin], context: nil)
        
        rectSize.size.width = max(kMinTFWidth, rectSize.width) + kPaddingWidth
        rectSize.size.height += kPaddingHeight
        
        return rectSize
    }
    
    // 获取当前文字内容，无内容时使用占位字符
    func getCurrentText() -> String {
        if self.text?.isEmpty ?? true {
            return self.placeholder ?? ""
        }
        
        return self.text!
    }
}

// 使用系统api添加约束
extension UIView {
    func edgesToSuperview(_ padding: CGFloat) {
        paddingToSuperView(left: padding, top: padding, right: padding, bottom: padding)
    }
    
    func topLeftToSuperview(_ padding: CGFloat, size: CGFloat) {
        paddingToSuperView(left: padding, top: padding, width: size, height: size)
    }
    
    func bottomRightToSuperview(_ padding: CGFloat, size: CGFloat) {
        paddingToSuperView(right: padding, bottom: padding, width: size, height: size)
    }
    
    /// 添加内边距
    private func paddingToSuperView(left: CGFloat? = nil,
                                    top: CGFloat? = nil,
                                    right: CGFloat? = nil,
                                    bottom: CGFloat? = nil,
                                    width: CGFloat? = nil,
                                    height: CGFloat? = nil) {
        
        // 开启约束布局
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let ops = NSLayoutConstraint.FormatOptions.alignAllLeft
        let views = ["view": self]
        
        if (left != nil) || (right != nil) {
            var hVfl = "H:"
            
            if left != nil {
                hVfl += "|-\(left!)-"
            }
            
            hVfl += "[view"
            
            if width != nil {
                hVfl += "(\(width!))"
            }
            
            hVfl += "]"
            
            if right != nil {
                hVfl += "-\(right!)-|"
            }
            
            let hConsts = NSLayoutConstraint.constraints(withVisualFormat: hVfl, options: ops, metrics: nil, views: views)
            self.superview?.addConstraints(hConsts)
        }
        
        if (top != nil) || (bottom != nil) {
            var vVfl = "V:"
            
            if top != nil {
                vVfl += "|-\(top!)-"
            }
            
            vVfl += "[view"
            
            if height != nil {
                vVfl += "(\(height!))"
            }
            
            vVfl += "]"
            
            if bottom != nil {
                vVfl += "-\(bottom!)-|"
            }
            
            let vConsts = NSLayoutConstraint.constraints(withVisualFormat: vVfl, options: ops, metrics: nil, views: views)
            self.superview?.addConstraints(vConsts)
        }
    }
}

extension VCBaseSticker {
    // 当transform为identity时的frame
    public var cFrame: CGRect {
        var rect = self.bounds
        rect.origin.x = self.center.x - rect.width / 2
        rect.origin.y = self.center.y - rect.height / 2
        
        return rect
    }
    
    // 当前的旋转弧度
    public var cAngle: CGFloat {
        let trans = self.transform
        
        return trans.b < 0 ? CGFloat.pi * 2 - acos(trans.a) : acos(trans.a)
    }
}

open class VCAsserts: NSObject {
    
    open class var closeImage: UIImage { return VCAsserts.bundledImage(named: "close") }
    open class var resizeImage: UIImage { return VCAsserts.bundledImage(named: "resize") }


    internal class func bundledImage(named name: String) -> UIImage {
        let primaryBundle = Bundle(for: VCAsserts.self)
        if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
            // Load image in cases where VCSticker is directly integrated
            return image
        } else if
            let subBundleUrl = primaryBundle.url(forResource: "VCResources", withExtension: "bundle"),
            let subBundle = Bundle(url: subBundleUrl),
            let image = UIImage(named: name, in: subBundle, compatibleWith: nil)
        {
            // Load image in cases where VCSticker is integrated via cocoapods as a dynamic or static framework with a separate resource bundle
            return image
        }

        return UIImage()
    }
}

