//
//  DateFormattingUtility.swift
//  Apple News
//
//  Created by igor on 8/6/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

/**
 Used to configure for
 each specific case
 
 */
enum UsageCase {
    case PubDate
    case TableHeader
}

/// Class for working with dates across the whole app
final class DateFormattingUtility: NSObject {
    
    private let PubDateDateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    private let TableHeaderDateFormat = "EEE, dd MMM"

    // MARK: - Properties
    
    static let sharedInstance = DateFormattingUtility()
    
    private let dateFormatter: NSDateFormatter
    
    // MARK: - Lifecycle
    
    override init() {
        dateFormatter = NSDateFormatter()
        super.init()
    }
    
    // MARK: - Public methods
    
    /**
     Set NSDateFormatter's date format for a specific case
     
     - parameter usageCase: Case to configure for
     */
    func configureForUsage(usageCase: UsageCase) {
        switch usageCase {
        case .PubDate:
            dateFormatter.dateFormat = PubDateDateFormat
        case .TableHeader:
            dateFormatter.dateFormat = TableHeaderDateFormat
        }
    }
    
    func dateFromString(string: String) -> NSDate? {
        return dateFormatter.dateFromString(string)
    }
    
    func stringFromDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
}
