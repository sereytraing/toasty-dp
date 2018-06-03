//
//  ToastyStyle.swift
//  Toasty
//
//  Created by TRAING Serey on 03/06/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import UIKit

public class ToastyStyleBuilder {
    public var cornerRadius:            CGFloat = 10.0
    public var backgroundColor:         UIColor = UIColor.red
    public var messageColor:            UIColor = .blue
    public var messageBackgroundColor:  UIColor = .clear
    public var messageAlignment:        NSTextAlignment = .center
    public var lineBreakMode:           NSLineBreakMode = .byTruncatingTail
    public var messageNumberOfLines:    Int = 0
    public var animationDuration:       Double = 3.0
    
    public typealias BuilderClosure = (ToastyStyleBuilder) -> ()
    
    public init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}


public struct ToastyStyle {
    public var cornerRadius:            CGFloat
    public var backgroundColor:         UIColor
    public var messageColor:            UIColor
    public var messageBackgroundColor:  UIColor
    public var messageAlignment:        NSTextAlignment
    public var lineBreakMode:           NSLineBreakMode
    public var messageNumberOfLines:    Int
    public var animationDuration:       Double
    
    public init(builder: ToastyStyleBuilder) {
        self.cornerRadius = builder.cornerRadius
        self.backgroundColor = builder.backgroundColor
        self.messageColor = builder.messageColor
        self.messageBackgroundColor = builder.messageBackgroundColor
        self.messageAlignment = builder.messageAlignment
        self.lineBreakMode = builder.lineBreakMode
        self.messageNumberOfLines = builder.messageNumberOfLines
        self.animationDuration = builder.animationDuration
    }
}
