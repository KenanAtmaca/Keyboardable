//
//
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit

typealias kbCompletion = ((CGFloat) -> Void)?

protocol Keyboardable: class {
    func keyboardObserver(completion: kbCompletion)
    func removeKeyboardObserver()
}

struct KeyboardKeys {
    static var show:UInt8 = 0
    static var hide:UInt8 = 1
}

extension Keyboardable where Self: UIViewController {
    
    private var keyboardShowObj: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardKeys.show) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeys.show, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var keyboardHideObj: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardKeys.hide) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeys.hide, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func getHeight(_ notification:Notification) -> CGFloat {
        guard let info = notification.userInfo else { return .leastNormalMagnitude }
        guard let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return .leastNormalMagnitude }
        let keyboardSize = value.cgRectValue.size
        return keyboardSize.height
    }
    
    func keyboardObserver(completion: kbCompletion) {
        
        keyboardShowObj = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { (notification) in
            
            let height = self.getHeight(notification)
          
            guard let comp = completion else {
                return
            }
            
            comp(height)
        })
        
        keyboardHideObj = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { (notification) in
        
            guard let comp = completion else {
                return
            }
            
            comp(0)
        })
    }
    
    func removeKeyboardObserver() {
        if let kshowObj = keyboardShowObj,
            let khideObj = keyboardHideObj {
            NotificationCenter.default.removeObserver(kshowObj)
            NotificationCenter.default.removeObserver(khideObj)
            keyboardHideObj = nil
            keyboardShowObj = nil
        }
    }
}


