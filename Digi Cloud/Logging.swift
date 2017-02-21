//
//  Logging.swift
//  Digi Cloud
//
//  Created by Mihai Cristescu on 21/11/16.
//  Copyright © 2016 Mihai Cristescu. All rights reserved.
//

import Foundation

public func DLog<T>(object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG_CONTROLLERS
        let queue = Thread.isMainThread ? "Main (UI)" : "Background"
        print("\n_____________________________________________________")
        print("File:        \((file as NSString).lastPathComponent)")
        print("Function:    \(function)")
        print("Line:        \(line)")
        print("Thread:      \(queue)")
        print("\(object())")
        print("_____________________________________________________\n")
    #endif
}
