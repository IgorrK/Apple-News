//
//  FeedViewController.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, XMLParserDelegate, FeedTableViewCoordinatorDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var tableViewCoordinator: FeedTableViewCoordinator!
    
    private let coreDataManager = CoreDataManager.sharedInstance
    private let parser = XMLParser()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCoordinator.delegate = self
        parser.delegate = self
        dispayFeed()
    }
    
    // MARK: - Private methods
    
    private func dispayFeed() {
        // TODO: check Internet connection
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        parser.beginParsing()

    }
    
    // MARK: - FeedTableViewCoordinatorDelegate
    
    func feedTableViewCoordinatorDidSelectItem(item: FeedItem) {
        print("selected: \(item)")
    }

    func feedTableViewCoordinatorDidRefresh() {
        dispayFeed()
    }
    
    // MARK: - XMLParserDelegate
    
    func parsingDidSucceed(result: [FeedItemData]) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        coreDataManager.storeFeedItemsFromData(result)
        let feedItems = coreDataManager.getCurrentFeedItems()
        if feedItems.count == 0 {
            let alertController = AlertsUtility.alertControllerOfType(AlertType.Other,
                                                                      message: Constants.Messages.EmptyFeedMsg)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        tableViewCoordinator.reloadData(feedItems)
    }
    
    func parsingDidFail(error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        let alertController = AlertsUtility.alertControllerOfType(AlertType.Error, message: error.localizedDescription)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
