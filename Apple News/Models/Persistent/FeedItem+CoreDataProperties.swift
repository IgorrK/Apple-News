//
//  FeedItem+CoreDataProperties.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FeedItem {

    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var pubDate: NSDate?
    @NSManaged var encodedContent: String?

}
