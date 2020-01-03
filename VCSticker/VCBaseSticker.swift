//
//  VCBaseSticker.swift
//  VCCapture
//
//  Created by Vincent on 2019/11/13.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

enum VCBorderStyle {
    case dotted
    case solid
    case none
}

let kMinFrameWidth: CGFloat  = 35
let kMinFrameHeight: CGFloat = 35

open class VCBaseSticker: UIView {
    public var onBeginEditing: (() -> Void)?
    public var onClose: (() -> Void)?
    
    var closeImage  = VCAsserts.closeImage
    var resizeImage = VCAsserts.resizeImage
    
    public var borderColor = UIColor.cyan {                // 外边框颜色
        didSet {
            border.strokeColor  = borderColor.cgColor
            closeBtn.tintColor  = borderColor.highlightColor()
            resizeBtn.tintColor = borderColor.highlightColor()
            closeBtn.backgroundColor  = borderColor
            resizeBtn.backgroundColor = borderColor
        }
    }
    var borderStyle = VCBorderStyle.solid           // 外边框样式
    var padding: CGFloat = 8                        // 内边距
    
    public var closeBtnEnable: Bool  = true                // 是否显示关闭按钮
    public var resizeBtnEnable: Bool = true                // 是否显示缩放按钮
    public var restrictionEnable: Bool = false             // 是否开启边缘限制
    
    
    public var initState = -1
    public var isEditing: Bool = false
    
    /// 记录缩放的开始时的状态
    private var lastAngle: CGFloat!
    private var lastDistance: CGFloat!
    
    private lazy var border: CAShapeLayer = {       // 外边框
        let layer = CAShapeLayer()
        
        layer.fillColor = nil                       // 禁用填充颜色
        
        switch self.borderStyle {
        case .none:
            layer.strokeColor = nil
        case .dotted:
            layer.lineDashPattern = [4, 3]          // 使用虚线边框
            fallthrough
        case .solid:
            fallthrough
        default:
            layer.strokeColor = borderColor.cgColor // 边框颜色
        }
        
        return layer
    }()
    
    private lazy var closeBtn: UIImageView = {             // 关闭按钮
        let button = self.getItemImageView(self.closeImage)
        
        return button
    }()
    
    private lazy var resizeBtn: UIImageView = {            // 缩放按钮
        let button = self.getItemImageView(self.resizeImage)
        
        return button
    }()
    
    lazy public var contentView = UIView()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if initState == -1 {
            initState = 0
            removeAutoLayout()
        } else if initState == 0 {
            initState = 1
            customInit()
        }
        
        border.path  = UIBezierPath(rect: contentView.bounds).cgPath
        border.frame = contentView.bounds
    }
    
    // 删除外部设置的无用约束(约束会影响当前代码中设置bound和frame的效果)
    private func removeAutoLayout() {
        // 遍历自身约束
        for con in self.constraints {
            self.removeConstraint(con)
        }
        
        // 遍历父视图约束
        if let superConstraints = self.superview?.constraints {
            for con in superConstraints {
                if con.firstItem?.isEqual(self) ?? false {
                    self.superview?.removeConstraint(con)
                }
            }
        }
        
        // 使用frame布局
        self.translatesAutoresizingMaskIntoConstraints = true
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /// 自定义初始化，为了兼容外部设置约束的情况，将初始化放在layoutSubviews中调用
    open func customInit() {
        frame.size.width = max(frame.width, kMinFrameWidth)
        frame.size.height = max(frame.height, kMinFrameHeight)
        
        setupSubViews()
        setupGestures()
        
        self.beginEditing()
    }
    
    /// 初始化subview，用VFL添加约束
    private func setupSubViews() {
        
        self.addSubview(contentView)
        self.contentView.edgesToSuperview(self.padding)
        
        if closeBtnEnable {
            self.addSubview(closeBtn)
            self.closeBtn.topLeftToSuperview(0, size: self.padding*2)
        }
        
        if resizeBtnEnable {
            self.addSubview(resizeBtn)
            self.resizeBtn.bottomRightToSuperview(0, size: self.padding*2)
        }
    }
    
    /// 初始化自定义手势
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(gesture:)))
        self.resizeBtn.addGestureRecognizer(resizeGesture)
        
        let bodyTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapBody))
        self.addGestureRecognizer(bodyTapGesture)
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapClose))
        self.closeBtn.addGestureRecognizer(closeTapGesture)
    }
    
    /// 获取图标按钮视图
    private func getItemImageView(_ image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.padding*2, height: self.padding*2))
        
        imageView.image = image
        imageView.tintColor = .black
        imageView.backgroundColor = self.borderColor
        imageView.layer.cornerRadius = self.padding
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }
    
    /// 开始编辑，显示控制组件
    open func beginEditing() {
        isEditing = true
        
        closeBtn.isHidden  = !closeBtnEnable
        resizeBtn.isHidden = !resizeBtnEnable
        contentView.layer.addSublayer(border)
        onBeginEditing?()
    }
    
    /// 结束编辑，隐藏控制组件
    open func finishEditing() {
        isEditing = false
        
        closeBtn.isHidden  = true
        resizeBtn.isHidden = true
        border.removeFromSuperlayer()
    }
}

// 手势动作
extension VCBaseSticker {
    
    /// 拖动手势
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if !isEditing {
            beginEditing()
        }
        
        // 1.获取手势在视图上的平移增量
        let translation = gesture.translation(in: gesture.view!.superview)
        // 2.设置中心点
        let center = gesture.view!.center
        let newCenter = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        // 判断是否超出边缘
        if restrictionEnable {
            if (newCenter.x + self.frame.width*0.5 <= self.superview!.frame.width)
                && (newCenter.x - self.frame.width*0.5 >= 0) {
                gesture.view!.center.x = newCenter.x
            }
            
            if (newCenter.y + self.frame.height*0.5 <= self.superview!.frame.height)
                && (newCenter.y - self.frame.height*0.5 >= 0) {
                gesture.view!.center.y = newCenter.y
            }
        } else {
            gesture.view!.center = newCenter
        }
        
        // 3.将上一次的平移增量置为0
        gesture.setTranslation(CGPoint(x: 0.0, y: 0.0), in: gesture.view)
    }
    
    /// 缩放控制
    @objc func handleResize(gesture: UIPanGestureRecognizer) {
        // 以当前父页面为计算参考
        let location = gesture.location(in: self.superview)
        let center = self.center
        
        let distance = VCStickerUtils.getDistance(point1: location, point2: center)
        let angle = atan2(location.y - center.y, location.x - center.x)
        
        
        if gesture.state == .began {
            self.lastAngle = angle
            self.lastDistance = distance
        } else if gesture.state == .changed {
            // 旋转
            let final = angle - self.lastAngle
            self.transform = self.transform.rotated(by: final)
            self.lastAngle = angle
            
            // 缩放
            let scale = distance / self.lastDistance
            
            let newWidth  = self.bounds.width * scale
            let newHeight = self.bounds.height * scale
            if (newWidth >= kMinFrameWidth) && (newHeight >= kMinFrameHeight) {
                // 修改当前view的真实大小（不使用transform）
                // self.transform = self.transform.scaledBy(x: scale, y: scale)
                self.bounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
                // 修改文字大小
                //                adjustTextFieldFont()
                
                self.lastDistance = distance
            }
        }
    }
    
    /// 点击关闭
    @objc func handleTapClose() {
        self.onClose?()
        self.removeFromSuperview()
    }
    
    /// 点击当前控件整体（显示/隐藏）
    @objc func handleTapBody() {
        isEditing ? finishEditing() : beginEditing()
    }
}
