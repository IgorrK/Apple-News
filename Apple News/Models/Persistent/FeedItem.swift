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
    private static let DateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
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
        feedItem.title = dictionary[XMLParser.keys.titleKey]
        feedItem.body = dictionary[XMLParser.keys.descriptionKey]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DateFormat
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let dateStr = dictionary[XMLParser.keys.pubDateKey]!
        feedItem.pubDate = dateFormatter.dateFromString(dateStr)!
        return feedItem
    }
    
}
