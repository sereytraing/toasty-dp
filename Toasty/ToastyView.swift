//
//  ToastyView.swift
//  Toasty
//
//  Created by TRAING Serey on 08/01/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import UIKit

/*public class ToastyView: UIView {

    static var toastyView = ToastyView()
    static var style = ToastyStyle()
    static var SIMPLE_MESSAGE = 1;
    static var MESSAGE_AND_IMAGE = 2;
    static var SIMPLE_IMAGE = 3;
    
    static var NO_TEXT = "no_text_found"
    static var NO_IMAGE = UIImage(named: "no_image", in: Bundle(for: ToastyView.self), compatibleWith: nil)!
    
    public static var LENGHT_SHORT = 1.0
    public static var LENGHT_LONG = 5.0
    
    public static var DEBUG_NO = UIColor.black.withAlphaComponent(0.8)
    public static var DEBUG_OK = UIColor.green.withAlphaComponent(0.8)
    public static var DEBUG_KO = UIColor.red.withAlphaComponent(0.8)
    
    public static func showToast(viewController: UIViewController, withSimpleMessage message: String?, toastyStyle: ToastyStyle? = nil, length: Double? = nil, isDebug: UIColor? = nil) {
        checkToastyStyle(style: toastyStyle, length: length, isDebug: isDebug)

        initToastyView(forToast: SIMPLE_MESSAGE, viewController)
        if let message = message {
            createMessage(message, forToast:SIMPLE_MESSAGE, with: nil)
        } else {
            createMessage(NO_TEXT, forToast:SIMPLE_MESSAGE, with: nil)
        }
        enableToast(viewController)
    }
    
    public static func showToast(viewController: UIViewController, withMessage message: String?, andImage image: UIImage?, toastyStyle: ToastyStyle? = nil, length: Double? = nil, isDebug: UIColor? = nil) {
        var imageView: UIImageView?
        checkToastyStyle(style: toastyStyle, length: length, isDebug: isDebug)

        initToastyView(forToast: MESSAGE_AND_IMAGE, viewController)
        
        if let image = image {
            imageView = createImage(image, forToast: SIMPLE_MESSAGE)
        } else {
            imageView = createImage(NO_IMAGE, forToast: SIMPLE_MESSAGE)

        }
        
        if let message = message {
            createMessage(message, forToast: MESSAGE_AND_IMAGE, with: imageView)
        } else {
            createMessage(NO_TEXT, forToast: MESSAGE_AND_IMAGE, with: imageView)
        }
        
        enableToast(viewController)
    }
    
    public static func showToast(viewController: UIViewController, withSimpleImage image: UIImage?, toastyStyle: ToastyStyle? = nil, length: Double? = nil, isDebug: UIColor? = nil) {
        checkToastyStyle(style: toastyStyle, length: length, isDebug: isDebug)
        initToastyView(forToast: SIMPLE_IMAGE, viewController)
        if let image = image {
            _ = createImage(image, forToast: SIMPLE_IMAGE)
        } else {
            _ = createImage(NO_IMAGE, forToast: SIMPLE_IMAGE)
        }
        enableToast(viewController)
    }
    
    static func initToastyView(forToast type: Int, _ viewController: UIViewController?) {
        let screenSize: CGRect = UIScreen.main.bounds
        toastyView.checkIsActive()
        
        //Position de la view ici
        if (type == SIMPLE_MESSAGE), let viewController = viewController {
            toastyView.frame = CGRect(x: 10, y: screenSize.height-60 , width: viewController.view.frame.size.width - 20, height: 50)
        } else if (type == MESSAGE_AND_IMAGE), let viewController = viewController {
            toastyView.frame = CGRect(x: 10, y: screenSize.height-110 , width: viewController.view.frame.size.width - 20, height: 100)
        } else {
            toastyView.frame = CGRect(x: screenSize.width/2 - 50, y: screenSize.height-110 , width: 100, height: 100)
        }
        toastyView.alpha = 0.0
        toastyView.layer.cornerRadius = ToastyView.style.cornerRadius
        toastyView.backgroundColor = style.backgroundColor
        toastyView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    }
    
    static func createMessage(_ message: String, forToast type: Int, with imageView: UIImageView?) {
        let ml = UILabel()
        ml.text = message
        ml.numberOfLines = ToastyView.style.messageNumberOfLines
        ml.textAlignment = style.messageAlignment
        ml.lineBreakMode = style.lineBreakMode
        ml.backgroundColor = style.messageBackgroundColor
        ml.textColor = style.messageColor
        toastyView.addSubview(ml)
        ml.translatesAutoresizingMaskIntoConstraints = false
        
        if (type == SIMPLE_MESSAGE) {
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
    
    static func createImage(_ image: UIImage, forToast type: Int) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0)
        toastyView.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        if (type == SIMPLE_MESSAGE) {
            NSLayoutConstraint(item: iv, attribute: .leftMargin, relatedBy: .equal, toItem: toastyView, attribute: .leftMargin, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: iv, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: toastyView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: iv, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80).isActive = true
            NSLayoutConstraint(item: iv, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80).isActive = true
        } else {
            NSLayoutConstraint(item: iv, attribute: .centerX, relatedBy: .equal, toItem: toastyView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: toastyView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: iv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
            NSLayoutConstraint(item: iv, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        }
        return iv
    }
    
    static func enableToast(_ viewController: UIViewController) {
        viewController.view.addSubview(toastyView)
        toastyView.show()
        toastyView.perform(#selector(hide), with: nil, afterDelay: ToastyView.style.animationDuration)
    }
    
    // MARK: Animations
    func show() {
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 1.0
        })
    }
    
    @objc func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func checkIsActive() {
        if self.alpha > 0.0 {
            self.removeFromSuperview()
        }
        ToastyView.toastyView = ToastyView()
    }
    
    static func checkToastyStyle(style: ToastyStyle?, length : Double?, isDebug : UIColor?){
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
            ToastyView.style = userStyle
        } else {
            ToastyView.style = ToastyStyle()
        }
    }
    
}

public struct ToastyStyle {
    public init() {}
    
    //ajoutez ce que vous voulez
    public var cornerRadius: CGFloat = 10.0
    public var backgroundColor: UIColor = ToastyView.DEBUG_NO
    public var messageColor: UIColor = .white
    public var messageBackgroundColor: UIColor = .clear
    public var messageAlignment: NSTextAlignment = .center
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var messageNumberOfLines = 0
    public var animationDuration = ToastyView.LENGHT_SHORT
}*/

