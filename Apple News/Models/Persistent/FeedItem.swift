//
//  FeedItem.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import Foundation
import CoreData


struct TemporaryFeedItem {
    var title: String?
    var body: String?
    var pubDate: NSDate?
}

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
    static func insertNewObjectIntoContext(context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(EntityName, inManagedObjectContext: context)
    }
    
    /**
     Create new entity object with data from dictionary
     and insert it into the specified context

     
     - parameter dictionary: Dictionary containing values for object properties
     - parameter inContext:  Managed Object Context to insert a new object
     
     - returns: Created object
     */
    static func initNewObject(dictionary: FeedItemData, inContext: NSManagedObjectContext) -> NSManagedObject {
        let feedItem = NSEntityDescription.insertNewObjectForEntityForName(EntityName, inManagedObjectContext: inContext) as! FeedItem
        feedItem.title = dictionary[XMLParser.keys.title]
        feedItem.body = dictionary[XMLParser.keys.description]
        feedItem.encodedContent = dictionary[XMLParser.keys.encodedContent]
        DateFormattingUtility.sharedInstance.configureForUsage(UsageCase.PubDate)
        let dateStr = dictionary[XMLParser.keys.pubDate]!
        feedItem.pubDate = DateFormattingUtility.sharedInstance.dateFromString(dateStr)
        return feedItem
    }
}
