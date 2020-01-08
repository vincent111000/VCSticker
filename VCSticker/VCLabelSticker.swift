//
//  VCLabelSticker.swift
//  VCCapture
//
//  Created by Vincent on 2019/11/13.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

public class VCLabelSticker: VCBaseSticker {
    
    public var shadowEnable: Bool = false {                // 是否显示文字阴影
        didSet {
            self.textField.layer.shadowColor = shadowColor
        }
    }
    public var placeHolder = "请输入文字" {                  // 占位字符
        didSet {
            self.textField.placeholder = placeHolder
        }
    }
    public var fontSize: CGFloat {          // 字体大小
        set {
            self.textField.font = self.textField.font?.withSize(newValue)
        }
        
        get {
            return self.textField.font?.pointSize ?? UIFont.systemFontSize
        }
    }
    public var textColor   = UIColor.black {               // 文字颜色
        didSet {
            self.textField.textColor = textColor
        }
    }
    public var text: String? {                              // 文本内容
        set {
            self.textField.text = newValue
        }
        get {
            return self.textField.text
        }
    }
    
    private var shadowColor: CGColor {
        return self.shadowEnable ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
    
    private lazy var textField: UITextField = {     // 文字输入框
        let textField = UITextField()
        
        textField.delegate  = self
        textField.tintColor = self.textColor        // 光标颜色
        textField.textColor = self.textColor        // 文字颜色
        
        textField.attributedPlaceholder = NSAttributedString(string:self.placeHolder,
                                                             attributes: [.foregroundColor: UIColor.gray])
        textField.textAlignment = .center
        
        // 设置阴影
        textField.layer.shadowColor   = shadowColor
        textField.layer.shadowOffset  = CGSize(width: 0, height: 5)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius  = 4.0
        
        textField.addTarget(self, action: #selector(textFieldValueDidChanged), for: .editingChanged)
        
        return textField
    }()
    
    public init(center: CGPoint) {
        let frame = CGRect(x: center.x - kMinFrameWidth / 2, y: center.y - kMinFrameWidth / 2, width: kMinFrameWidth, height: kMinFrameWidth)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // mark - 重写父类的方法
    override open func customInit() {
        super.customInit()
        self.contentView.addSubview(textField)
        textField.edgesToSuperview(0)
        adjustFrameWithContent()
    }
    
    override public func finishEditing() {
        super.finishEditing()
        textField.resignFirstResponder()
    }
}

extension VCLabelSticker: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isEditing {
            return true
        }
        beginEditing()

        return false
    }
    
    private func adjustFrameWithContent() {
        let tfFrame = textField.adjustsWidthToFillContents()
        self.bounds.size.width = tfFrame.width + 2*self.padding
        self.bounds.size.height = tfFrame.height + 2*self.padding
    }
    
    @objc private func textFieldValueDidChanged() {
        adjustFrameWithContent()
    }
    
    func adjustTextFieldFont() {
        self.textField.adjustsFontSizeToFillRect(self.bounds.insetBy(dx: self.padding, dy: self.padding))
    }
}

// 重写父类的方法
extension VCLabelSticker {
  
    override func handlePanGesture(gesture: UIPanGestureRecognizer) {
        super.handlePanGesture(gesture: gesture)
        textField.resignFirstResponder()
    }
    
    override func handleResize(gesture: UIPanGestureRecognizer) {
        super.handleResize(gesture: gesture)
        
        // 修改文字大小
        adjustTextFieldFont()
    }
}
