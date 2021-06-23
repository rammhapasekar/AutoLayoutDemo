//
//  Extensions.swift
//  Demo
//
//  Created by Ram Mhapasekar on 23/06/21.
//

import Foundation
import UIKit

var activeTextField: UITextField!

extension ViewController{
    //MARK: Keyboard notification observer Methods
    @objc func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let activeTextField = activeTextField { // this method will get called even if a system generated alert with keyboard appears over the current VC.
            let info: NSDictionary = notification.userInfo! as NSDictionary
            let value: NSValue = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
            var keyboardSize: CGSize = value.cgRectValue.size
            keyboardSize.height = keyboardSize.height + 60
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            let subviews = view.subviews//.filter{$0.superclass == UIScrollView.self}
            var scrollView: UIScrollView!
            
            scrollView = scrollview
            
//            for i in 0..<subviews.count{
//                if let scrollview = subviews[i] as? UIScrollView{
//                    scrollView = scrollview
//                    break
//                }
//            }
            
            guard let scrollview = scrollView else {
                defer {
                    #if DEBUG
                    print("View controller does't contain scrollview")
                    #endif
                }
                return
            }
            scrollview.contentInset = contentInsets
            scrollview.scrollIndicatorInsets = contentInsets
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            let activeTextFieldRect: CGRect? = activeTextField.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if (!aRect.contains(activeTextFieldOrigin!)) {
                scrollview.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        let subviews = view.subviews
        for i in 0..<subviews.count{
            if let scrollview = subviews[i] as? UIScrollView{
                scrollview.contentInset = contentInsets
                scrollview.scrollIndicatorInsets = contentInsets
                break
            }
        }
    }
}
