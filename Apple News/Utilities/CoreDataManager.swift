//
//  CoreDataManager.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit
import CoreData

/// Separate class responsible for interaction with CoreData.
final class CoreDataManager: NSObject {
    
    // MARK: - Properties
    
    static let sharedInstance = CoreDataManager()
    
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - Public methods
    
    /**
     Transforms an array of data dictionaries
     into FeedItem objects and save them to the storage.
     
     - parameter data: Array containing FeedItems' data to save.
     */
    func storeFeedItemsFromData(data: [FeedItemData])  {
        // Delete the old feed
        deleteOldFeedItems()

        // Transform data to FeedItem objects
        data.forEach {
            createNewFeedItemFromDictionary($0)
        }
        
        // Save changes
        updateMOC()
    }
    
    /**
     Fetches current FeedItems from the database,
     sorted descending by date.
     
     - returns: Array of FeedItem objects.
     */
    func getCurrentFeedItems() -> [FeedItem] {
        // Form a fetch request for items, sorted by date
        let fetchRequest = NSFetchRequest(entityName: FeedItem.entityName())
        let sortDescriptor = NSSortDescriptor(key: FeedItem.AttributeKeys.pubDate, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute fetch request
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results as! [FeedItem]
        } catch {
            print("!!FETCH error: \(error)")
            return [FeedItem]()
        }
    }
    
    // MARK: - Private methods
    
    /**
     Creates an instance of the class for the entity with a given name,
     inserted into the default managed object context.
     
     - parameter entityName: The name of an entity.
     
     - returns: A new instance of the class for the entity with a given name.
     */
    private func insertNewObjectForEntityForName(entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext)
    }
    
    
    /**
     Creates and an instance of FeedItem class, inserted into the default 
     managed object context and configures it with the parameters given in dictionary.
     
     - parameter dictionary: Dictionary containing paramaters of instance configuration.
     
     - returns: A new configured instance of FeedItem class
     */
    private func createNewFeedItemFromDictionary(dictionary: FeedItemData) -> FeedItem? {
        // Create basic instance
        guard let feedItem = insertNewObjectForEntityForName(FeedItem.entityName()) as? FeedItem else {
            print("error creating object")
            return nil
        }
        
        // Set attributes:
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
    
    /**
     Deletes previously stored feed items from the database.
     */
    private func deleteOldFeedItems() {
        let fetchRequest = NSFetchRequest(entityName: FeedItem.entityName())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.executeRequest(deleteRequest)
        } catch {
            print("!!DELETE error: \(error)")
        }
    }
    
    /**
     Saves latest changes to the default managed object context.
     */
    private func updateMOC() {
        do {
            try managedObjectContext.save()
        } catch {
            print("!!MOC error: \(error)")
        }
    }
    
}
