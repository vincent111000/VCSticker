//
//  ViewController.swift
//  VCStickerDemo
//
//  Created by Vincent on 2019/12/30.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var mSticker: VCBaseSticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchOutside))
        self.view.addGestureRecognizer(tap)
    }
    
    /// 点击空白处时关闭正在编辑的标签
    @objc func touchOutside() {
        self.mSticker?.finishEditing()
        self.mSticker = nil
    }
    
    @IBAction func addLabelSticker(_ sender: UIButton) {
        let label = VCLabelSticker(center: self.view.frame.randomPoint)
        self.view.addSubview(label)
        
        label.textColor = UIColor.randomColor
        label.borderColor = UIColor.randomColor
        label.text = "666"
        label.closeBtnEnable  = true                // 是否显示关闭按钮
        label.resizeBtnEnable = true                // 是否显示缩放按钮
        label.restrictionEnable = true              // 开启边缘限制
        label.onBeginEditing = {
            if label != self.mSticker {
                self.mSticker?.finishEditing()
                self.mSticker = label
            }
        }
    }
    
    @IBAction func addImageSticker(_ sender: Any) {
        let image = VCImageSticker(frame: CGRect(x: 20, y: 120, width: 200, height: 200))
        image.imageView.image = UIImage(named: "test")
        image.borderColor = UIColor.randomColor
        self.view.addSubview(image)
        
        image.onBeginEditing = {
            if image != self.mSticker {
                self.mSticker?.finishEditing()
                self.mSticker = image
            }
        }
    }
    
    @IBAction func showOCDemo(_ sender: Any) {
        let controller = OCDemoViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}


extension UIColor {
    // 随机颜色
    class var randomColor: UIColor {
        get {
            let red   = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue  = CGFloat(arc4random() % 256) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

extension CGRect {
    // 生成随机坐标点
    var randomPoint: CGPoint {
        let x = random(min: Int(self.minX), max: Int(self.maxX))
        let y = random(min: Int(self.minY), max: Int(self.maxY))
        return CGPoint(x: x, y: y)
    }
    
    func random(min: Int, max: Int) -> Int {
        return Int(arc4random() % UInt32(max) + UInt32(min))
    }
}
