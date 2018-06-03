//
//  ToastyStrategy.swift
//  Toasty
//
//  Created by TRAING Serey on 03/06/2018.
//  Copyright © 2018 TRAING Serey. All rights reserved.
//

import Foundation

public protocol ToastyPrintStrategy {
    func print(_ string: String) -> String
}

public class ToastyPrint {
    
    public let strategy: ToastyPrintStrategy
    
    public func print(_ string: String) -> String {
        return self.strategy.print(string)
    }
    
    public init(strategy: ToastyPrintStrategy) {
        self.strategy = strategy
    }
}

public class UpperCaseStrategy: ToastyPrintStrategy {
    public init(){}
    public func print(_ string: String) -> String {
        return string.uppercased()
    }
}

public class LowerCaseStrategy: ToastyPrintStrategy {
    public init(){}
    public func print(_ string:String) -> String {
        return string.lowercased()
    }
}
