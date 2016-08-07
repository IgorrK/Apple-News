//
//  FeedItem.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import Foundation
import CoreData

class FeedItem: NSManagedObject {
    
    // - Properties
    
    private static let EntityName = "FeedItem"
    
    // - Class methods
    
    /**
     Get Core Data entity name
     
     - returns: Entity name
     */
    static func entityName() -> String {
        return EntityName
    }
    
    /**
     Create new entity object and insert it
     into the specified context
     
     - parameter context: Managed Object Context to insert a new object

     - returns: Created object
     */
    static func insertNewObjectIntoContext(context: NSManagedObjectContext) -> FeedItem? {
        return NSEntityDescription.insertNewObjectForEntityForName(EntityName, inManagedObjectContext: context) as? FeedItem
    }
    
    /**
     Create new entity object with data from dictionary
     and insert it into the specified context

     
     - parameter dictionary: Dictionary containing values for object properties
     - parameter inContext:  Managed Object Context to insert a new object
     
     - returns: Created object
     */
    static func initNewObject(dictionary: FeedItemData, inContext: NSManagedObjectContext) -> NSManagedObject? {
        // Create object
        guard let feedItem = FeedItem.insertNewObjectIntoContext(inContext) else {
            print("error creating object")
            return nil
        }
        
        // Title
        feedItem.title = dictionary[XMLParser.keys.title]
        
        // Plain and HTML-encoded body. Decided to store both because
        // HTML-encoded text is required for displaying hyperlinks on Feed Details screen
        // and plain text is used in Feed table, and transforming from HTML each
        // time would overload the main thread, causing animation lags and 
        // affecting preformance.
        feedItem.body = dictionary[XMLParser.keys.description]
        feedItem.encodedContent = dictionary[XMLParser.keys.encodedContent]
        
        // Date
        let dateStr = dictionary[XMLParser.keys.pubDate]!
        DateFormattingUtility.sharedInstance.configureForUsage(UsageCase.PubDate)
        feedItem.pubDate = DateFormattingUtility.sharedInstance.dateFromString(dateStr)
        
        return feedItem
    }
}
