//
//  logger.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 6. 3..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import SwiftyBeaver

// This just encapsulates the SwiftyBeaver Logger
struct Logger {
    let cloud: SBPlatformDestination
    
    init() {
        let console = ConsoleDestination()
        let file = FileDestination()
        
        cloud = SBPlatformDestination(
            appID: "xxxxxx",
            appSecret: "xxxxxxxxxx",
            encryptionKey: "xxxxxxxxxxxx"
        )
        
        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)
        SwiftyBeaver.addDestination(cloud)
        SwiftyBeaver.info("Logging to file: \(file.logFileURL?.path ?? "")")
    }
    
    func set(username: String) {
        cloud.analyticsUserName = username
    }
    
    func verbose(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
        ) {
        SwiftyBeaver.verbose(message, file, function, line: line)
    }
    
    func debug(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
        ) {
        SwiftyBeaver.debug(message, file, function, line: line)
    }
    
    func info(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
        ) {
        SwiftyBeaver.info(message, file, function, line: line)
    }
    
    func warning(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
        ) {
        SwiftyBeaver.warning(message, file, function, line: line)
    }
    
    func error(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
        ) {
        SwiftyBeaver.error(message, file, function, line: line)
    }
}

let log = Logger()
