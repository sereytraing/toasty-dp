//
//  ToastyObserver.swift
//  Toasty
//
//  Created by TRAING Serey on 03/06/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import Foundation

protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Bool)
}

// MARK: - OBSERVER
final class ToastyObserver {
    weak var observer:PropertyObserver?
    private let propertyNameToasty = "toasty"
    
    var isHidden: Bool = true {
        willSet(newValue) {
            observer?.willChange(propertyName: self.propertyNameToasty, newPropertyValue: newValue)
        }
    }
}

final class Observer : PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Bool) {
        if newPropertyValue {
            print("Observer: Toast hidden")
        } else {
            print("Observer: Toast did appear")
        }
    }
    
}
