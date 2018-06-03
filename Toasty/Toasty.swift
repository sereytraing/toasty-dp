//
//  Toasty.swift
//  Toasty
//
//  Created by TRAING Serey on 03/06/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import UIKit

public class Toasty {
    
    public static let shared = Toasty()
    var toastyView = UIView()
    var style = ToastyStyle()
    
    let LENGHT_SHORT = 1.0
    let LENGHT_LONG = 5.0
    let SIMPLE_MESSAGE = 1;
    let MESSAGE_AND_IMAGE = 2;
    let SIMPLE_IMAGE = 3;
    
    public static func showToast(viewController: UIViewController, withSimpleMessage message: String?, toastyStyle: ToastyStyle? = nil, length: Double? = nil, isDebug: UIColor? = nil) {
        self.shared.checkToastyStyle(style: toastyStyle, length: length, isDebug: isDebug)
        
        self.shared.initToastyView(forToast: 1, viewController)
        if let message = message {
            self.shared.createMessage(message, forToast:1, with: nil)
        } else {
            self.shared.createMessage("", forToast:1, with: nil)
        }
        self.shared.enableToast(viewController)
    }
    
    public func killToast() {
        self.toastyView.removeFromSuperview()
    }
    
    private func initToastyView(forToast type: Int, _ viewController: UIViewController?) {
        let screenSize: CGRect = UIScreen.main.bounds
        self.checkIsActive(view: self.toastyView)
        
        //Position de la view ici
        if (type == SIMPLE_MESSAGE), let viewController = viewController {
            toastyView.frame = CGRect(x: 10, y: screenSize.height-60 , width: viewController.view.frame.size.width - 20, height: 50)
        } else if (type == MESSAGE_AND_IMAGE), let viewController = viewController {
            toastyView.frame = CGRect(x: 10, y: screenSize.height-110 , width: viewController.view.frame.size.width - 20, height: 100)
        } else {
            toastyView.frame = CGRect(x: screenSize.width/2 - 50, y: screenSize.height-110 , width: 100, height: 100)
        }
        toastyView.alpha = 0.0
        toastyView.layer.cornerRadius = style.cornerRadius
        toastyView.backgroundColor = style.backgroundColor
        toastyView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    }
    
    private func createMessage(_ message: String, forToast type: Int, with imageView: UIImageView?) {
        let ml = UILabel()
        ml.text = message
        ml.numberOfLines = style.messageNumberOfLines
        ml.textAlignment = style.messageAlignment
        ml.lineBreakMode = style.lineBreakMode
        ml.backgroundColor = style.messageBackgroundColor
        ml.textColor = style.messageColor
        toastyView.addSubview(ml)
        ml.translatesAutoresizingMaskIntoConstraints = false
        
        if (type == 1) {
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: toastyView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: toastyView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: toastyView.frame.width - 40).isActive = true
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30).isActive = true
        } else if let imageView = imageView{
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: toastyView.frame.width - 90).isActive = true //90 parce que 80 taille image et 10 en plus comme ça pour pas coller
            NSLayoutConstraint(item: ml, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80).isActive = true
            NSLayoutConstraint(item: ml, attribute: .leftMargin, relatedBy: .equal, toItem: imageView, attribute: .rightMargin, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: ml, attribute: .centerY, relatedBy: .equal, toItem: toastyView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    private func checkIsActive(view: UIView) {
        if view.alpha > 0.0 {
            view.removeFromSuperview()
        }
        self.toastyView = UIView()
    }
    
    private func enableToast(_ viewController: UIViewController) {
        viewController.view.addSubview(toastyView)
        self.show()
        //toastyView.perform(#selector(hide), with: nil, afterDelay: style.animationDuration)
        self.hide()
    }
    
    // MARK: Animations
    private func show() {
        UIView.animate(withDuration: 0.33, animations: {
            self.toastyView.alpha = 1.0
        })
    }
    
    private func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            UIView.animate(withDuration: 0.33, animations: {
                self.toastyView.alpha = 0.0
            }, completion: { _ in
                self.toastyView.removeFromSuperview()
            })
        }
        
    }
    
    ///// STYLE //////
    private func checkToastyStyle(style: ToastyStyle?, length : Double?, isDebug : UIColor?){
        if var userStyle = style {
            if let userLength = length {
                userStyle.animationDuration = userLength
            }
            if let userIsDebug = isDebug {
                userStyle.backgroundColor = userIsDebug
            }
            
            if userStyle.animationDuration > LENGHT_LONG {
                userStyle.animationDuration = LENGHT_LONG
            } else if userStyle.animationDuration > LENGHT_SHORT {
                userStyle.animationDuration = LENGHT_SHORT
            }
            if userStyle.messageNumberOfLines > 5{
                userStyle.messageNumberOfLines = 5
            }
            self.style = userStyle
        } else {
            self.style = ToastyStyle()
        }
    }
    //////////////////
}

public struct ToastyStyle {
    public init() {}
    
    //ajoutez ce que vous voulez
    public var cornerRadius: CGFloat = 10.0
    public var backgroundColor: UIColor = UIColor.red
    public var messageColor: UIColor = .blue
    public var messageBackgroundColor: UIColor = .clear
    public var messageAlignment: NSTextAlignment = .center
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var messageNumberOfLines = 0
    public var animationDuration = 3.0
}
