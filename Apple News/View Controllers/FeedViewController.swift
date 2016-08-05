//
//  FeedViewController.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, XMLParserDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var tableViewCoordinator: FeedTableViewCoordinator!
    
    private let coreDataManager = CoreDataManager.sharedInstance
    private let parser = XMLParser()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = [["1", "2", "3", "4", "5"], ["A", "B", "C", "D"], ["x", "y", "z"]]
//        tableViewCoordinator.reloadData(items)
        parser.delegate = self
        dispayFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func dispayFeed() {
        // TODO: check Internet connection
        parser.beginParsing()

    }
    
    
    // MARK: - XMLParserDelegate
    
    func parsingDidSucceed(result: [FeedItemData]) {
        coreDataManager.storeFeedItemsFromData(result)
        let feedItems = coreDataManager.getCurrentFeedItems()
        tableViewCoordinator.reloadData(feedItems)
    }
    
    func parsingDidFail(error: NSError) {
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


