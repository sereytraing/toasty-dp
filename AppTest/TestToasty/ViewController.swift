//
//  ViewController.swift
//  TestToasty
//
//  Created by TRAING Serey on 15/01/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import UIKit
import Toasty

class ViewController: UIViewController {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var killButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftView.layer.masksToBounds = true
        self.middleView.layer.masksToBounds = true
        self.rightView.layer.masksToBounds = true
        self.leftView.layer.cornerRadius = 20.0
        self.middleView.layer.cornerRadius = 20.0
        self.rightView.layer.cornerRadius = 20.0
        self.killButton.layer.cornerRadius = 25.0
        self.textView.layer.cornerRadius = 10.0
    }
 

    @IBAction func testButtonClicked(_ sender: Any) {
        let message = "Yoyoyo"
        //Strategy
        let upper = ToastyPrint(strategy: UpperCaseStrategy())
        let nameSave = "save"
        Toasty.showToast(viewController: self, withSimpleMessage: upper.print(message))
        
        //Memento
        Toasty.shared.saveMessage(nameSave: nameSave, message: message)
        if let message = Toasty.shared.loadMessage(nameSave: nameSave) {
            print("My message is: " + message)
        }
    }
    
    @IBAction func imageAndMessageClicked(_ sender: Any) {
        let toastyStyleBuilder = ToastyStyleBuilder { builder in
            builder.animationDuration = 10.0
            builder.backgroundColor = .yellow
            builder.cornerRadius = 20.0
            builder.messageColor = .green
        }
        
        let style: ToastyStyle = ToastyStyle(builder: toastyStyleBuilder)
        Toasty.showToast(viewController: self, withMessage: "Osu !", andImage: UIImage(named: "fourstar"),toastyStyle: style)
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        Toasty.showToast(viewController: self, withSimpleImage: UIImage(named: "fourstar"))
    }
    @IBAction func killClicked(_ sender: Any) {
        Toasty.shared.killToast()
    }
}

