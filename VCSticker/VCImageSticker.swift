//
//  VCImageSticker.swift
//  VCCapture
//
//  Created by Vincent on 2019/11/13.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

public class VCImageSticker: VCBaseSticker {
    @objc public var imageView = UIImageView()
    
    override open func customInit() {
         super.customInit()
         self.contentView.addSubview(imageView)
         imageView.edgesToSuperview(0)
     }
}
