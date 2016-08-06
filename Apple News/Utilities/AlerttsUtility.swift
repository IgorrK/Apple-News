//
//  AlertsUtility.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

enum AlertType: String {
    case Other = ""
    case Error = "Error"
    case Warning = "Warning"
}

/// Factory that generates customized UIAlertController objects for a set of specific cases
final class AlertsUtility: NSObject {

    /**
     Create general Alert Controller of specified type
     with message and "OK" button without any action
    
     - parameter type:    Type of alert title
     - parameter message: Alert message
     
     - returns: Created Alert Controller
     */
    static func alertControllerOfType(type: AlertType, message: String) -> UIAlertController {
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        return AlertsUtility.alertControllerOfType(type, message: message, actions: [ok])
    }
    
    /**
     Create general Alert Controller of specified type
     with message and custom actions
     
     - parameter type:    Type of alert title
     - parameter message: Alert message
     - parameter actions: Alert actions
     
     - returns: Created Alert Controller
     */
    static func alertControllerOfType(type: AlertType, message: String, actions:[UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: type.rawValue, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for action: UIAlertAction in actions {
            alertController.addAction(action)
        }
        return alertController
    }
    
}
