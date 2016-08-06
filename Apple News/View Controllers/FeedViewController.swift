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
    
    static let ShowDetailsSegueId = "showDetails"
    
    @IBOutlet var tableViewCoordinator: FeedTableViewCoordinator!
    
    private let coreDataManager = CoreDataManager.sharedInstance
    private let parser = XMLParser()
    private var selectedItem: FeedItem?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCoordinator.delegate = self
        parser.delegate = self
        loadFeed()
    }
    
    // MARK: - Private methods
    
    /**
     Request feed from Apple RSS or get cached data depending on network status
     */
    private func loadFeed() {
        if NetworkReachability.isConnected() {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            parser.beginParsing()
        } else {
            // Explicit call from main quue is required because when application
            // has just launched, view controller's UI could be not fully loaded
            // and call of .presentViewController() will cause a warning
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = AlertsUtility.alertControllerOfType(AlertType.Warning,
                    message: Constants.Messages.ShowingCachedFeedMsg)
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            showCurrentFeed()
        }
    }
    
    /**
     Fetch items from the database and reload table
     */
    private func showCurrentFeed() {
        let feedItems = coreDataManager.getCurrentFeedItems()
        if feedItems.count == 0 {
            // Same reason here
            dispatch_async(dispatch_get_main_queue(), {
            let alertController = AlertsUtility.alertControllerOfType(AlertType.Other,
                                                                      message: Constants.Messages.EmptyFeedMsg)
            self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
        tableViewCoordinator.reloadData(feedItems)

    }
    
    // MARK: - FeedTableViewCoordinatorDelegate
    
    func feedTableViewCoordinatorDidSelectItem(item: FeedItem) {
        selectedItem = item
        performSegueWithIdentifier(FeedViewController.ShowDetailsSegueId, sender: self)
    }

    func feedTableViewCoordinatorDidRefresh() {
        loadFeed()
    }
    
    // MARK: - XMLParserDelegate
    
    func parsingDidSucceed(result: [FeedItemData]) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        coreDataManager.storeFeedItemsFromData(result)
        showCurrentFeed()
    }
    
    func parsingDidFail(error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        let alertController = AlertsUtility.alertControllerOfType(AlertType.Error, message: error.localizedDescription)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
     // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let detailsVC = segue.destinationViewController as? FeedDetailsViewController else {
            print("segue error")
            return
        }
        detailsVC.itemToPresent = selectedItem
     }
    
}
