//
//  CoreDataManager.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit
import CoreData

/// Separate class responsible for interaction with CoreData
final class CoreDataManager: NSObject {
    // MARK: - Properties
    static let sharedInstance = CoreDataManager()
    
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - Public methods
    
    /**
     Transform an array of data dictionaries
     into FeedItem objects and save them to the storage
     
     - parameter data: Array containing FeedItems' data to save
     */
    func storeFeedItemsFromData(data: [FeedItemData])  {
        // Delete the old feed
        deleteOldFeedItems()
        
        // Transform data to FeedItem objects
        data.forEach { feedItemData in
            FeedItem.initNewObject(feedItemData, inContext: managedObjectContext)
        }
        
        // Save changes
        updateMOC()
    }
    
    /**
     Fetch current FeedItems from the database
     
     - returns: Array of FeedItems
     */
    func getCurrentFeedItems() -> [FeedItem] {
        let fetchRequest = NSFetchRequest(entityName: FeedItem.entityName())
        let sortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
     Delete old FeedItems from the database
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
     Generic method for saving latest changes to the MOC
     */
    private func updateMOC() {
        do {
            try managedObjectContext.save()
        } catch {
            print("!!MOC error: \(error)")
        }
    }
}
