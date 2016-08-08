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
    
    /**
     *  A structure with names of managed object's attributes.
     */
    struct AttributeKeys {
        static let Title = "title"
        static let Body = "body"
        static let EncodedContent = "encodedContent"
        static let pubDate = "pubDate"
    }
    
    // - Class methods
    
    /**
     Returns the name of entity used for storing in CoreData.
     
     - returns: The name of the enity.
     */
    static func entityName() -> String {
        return EntityName
    }
}
