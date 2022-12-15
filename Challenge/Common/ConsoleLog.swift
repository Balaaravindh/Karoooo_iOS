//
//  ConsoleLog.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation

class ConsoleLog { // ConsoleLog file only prints in debug more not in release mode.
    
    #if DEBUG
    static var isLoggingEnabled = true
    #else
    static var isLoggingEnabled = false
    #endif
    
    class func pt(_ object: Any) {
        Swift.print(object)
    }
    
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if ConsoleLog.isLoggingEnabled {
            pt("-> \(object)")
        }
    }
    
}
