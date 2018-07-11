//
//  Toasty.swift
//  Toasty
//
//  Created by TRAING Serey on 03/06/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import UIKit

/*
 Design Pattern:
 - Singleton : The singleton pattern ensures that only one object of a particular class is ever created. All further references to objects of the singleton class refer to the same underlying instance. There are very few applications, do not overuse this pattern!
        Project -> var shared in Toasty.swift
 
 - Builder: The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm. An external class controls the construction algorithm.
        Project -> in ToastyStyle.swift
 
 - Non null: Check if the variable is null
        Project -> check with 'if let' in Toast.swift
 
 - Observer: The observer pattern is used to allow an object to publish changes to its state. Other objects subscribe to be immediately notified of any changes.
        Project -> in ToastyObserver.swift
 
 - Facade: The facade pattern is used to define a simplified interface to a more complex subsystem.
        Project -> func showToast(...) in Toasty.swift
 
 - Memento: The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.
        Project -> Add message in UserDefaults, save/load in Toasty.swift (useless imo)
 
 - ??? Command: The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.
        Project -> if toasty did appear, i can kill it with the function killToasty and I roll back to the initial view ?
 
 - Strategy: The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.
        No idea of use
        Project -> in ToastyStrategy.swift, manage upper/lowercase (useless imo)
 
 - Adapter(Couleur): Adapt hexcolor to UIColor
    -> Extension d'UIColor, func for using func
 
 - Delegate
 
 Inspired by : https://github.com/ochococo/Design-Patterns-In-Swift
 
 */



public class Toasty {
    public static let shared = Toasty()
    let defaults = UserDefaults.standard
    var observerInstance = Observer()
    var toastyObserver = ToastyObserver()
    var toastyView = UIView()
    let toastyStyleBuilder = ToastyStyleBuilder { builder in
        builder.animationDuration = 10.0
    }
    
    lazy var style: ToastyStyle = ToastyStyle(builder: toastyStyleBuilder)
    
    let LENGHT_SHORT = 1.0
    let LENGHT_LONG = 5.0
    let SIMPLE_MESSAGE = 1;
    let MESSAGE_AND_IMAGE = 2;
    let SIMPLE_IMAGE = 3;
    
    // MARK: - FACADE
    public static func showToast(viewController: UIViewController, withSimpleMessage message: String?, toastyStyle: ToastyStyle? = nil, length: Double? = nil) {
        self.shared.checkToastyStyle(style: toastyStyle, length: length)
        
        self.shared.initToastyView(forToast: self.shared.SIMPLE_MESSAGE, viewController)
        // MARK: - NON NULL
        if let message = message {
            self.shared.createMessage(message, forToast: self.shared.SIMPLE_MESSAGE, with: nil)
        } else {
            self.shared.createMessage("", forToast: self.shared.SIMPLE_MESSAGE, with: nil)
        }
        self.shared.enableToast(viewController)
    }
    
    public static func showToast(viewController: UIViewController, withMessage message: String?, andImage image: UIImage?, toastyStyle: ToastyStyle? = nil, length: Double? = nil) {
        var imageView: UIImageView?
        self.shared.checkToastyStyle(style: toastyStyle, length: length)
        self.shared.initToastyView(forToast: self.shared.MESSAGE_AND_IMAGE, viewController)
        if let image = image {
            imageView = self.shared.createImage(image, forToast: self.shared.SIMPLE_MESSAGE)
        }
        if let message = message {
            self.shared.createMessage(message, forToast: self.shared.MESSAGE_AND_IMAGE, with: imageView)
        } else {
            self.shared.createMessage("", forToast: self.shared.MESSAGE_AND_IMAGE, with: imageView)
        }
        
        self.shared.enableToast(viewController)
    }
    
    public static func showToast(viewController: UIViewController, withSimpleImage image: UIImage?, toastyStyle: ToastyStyle? = nil, length: Double? = nil) {
        self.shared.checkToastyStyle(style: toastyStyle, length: length)
        self.shared.initToastyView(forToast: self.shared.SIMPLE_IMAGE, viewController)
        if let image = image {
            _ = self.shared.createImage(image, forToast: self.shared.SIMPLE_IMAGE)
        }
        self.shared.enableToast(viewController)
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
    
    
    func createImage(_ image: UIImage, forToast type: Int) -> UIImageView {
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
    
    private func checkIsActive(view: UIView) {
        if view.alpha > 0.0 {
            view.removeFromSuperview()
        }
        self.toastyView = UIView()
    }
    
    private func enableToast(_ viewController: UIViewController) {
        viewController.view.addSubview(toastyView)
        self.show()
        self.hide()
    }
    
    // MARK: Animations
    private func show() {
        self.toastyObserver.observer = observerInstance
        UIView.animate(withDuration: 0.33, animations: {
            self.toastyView.alpha = 1.0
            self.toastyObserver.isHidden = false
        })
    }
    
    private func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.style.animationDuration) {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            UIView.animate(withDuration: 0.33, animations: {
                self.toastyView.alpha = 0.0
            }, completion: { _ in
                self.toastyView.removeFromSuperview()
                self.toastyObserver.isHidden = true
            })
        }
    }
    
    private func checkToastyStyle(style: ToastyStyle?, length : Double?){
        if var userStyle = style {
            if let userLength = length {
                userStyle.animationDuration = userLength
            }
            if userStyle.animationDuration > LENGHT_LONG {
                userStyle.animationDuration = LENGHT_LONG
            } else if userStyle.animationDuration > LENGHT_SHORT {
                userStyle.animationDuration = LENGHT_SHORT
            }
            if userStyle.messageNumberOfLines > 5 {
                userStyle.messageNumberOfLines = 5
            }
            self.style = userStyle
        } else {
            self.style = ToastyStyle(builder: self.toastyStyleBuilder)
        }
    }
    //////////////////
    
    // MARK: - COMMAND ? Peut etre
    public func killToast() {
        self.toastyView.removeFromSuperview()
    }
    
    // MARK: - MEMENTO
    public func saveMessage(nameSave: String, message: String) {
        self.defaults.set(message, forKey: nameSave)
        self.defaults.synchronize()
    }
    
    public func loadMessage(nameSave: String) -> String? {
        return self.defaults.string(forKey: nameSave)
    }
    
    // MARK: - ADAPTER
    public static func colorHex(color: Int) -> UIColor {
        return UIColor(rgb: color)
    }
}
