//
//  FeedDetailsViewController.swift
//  Apple News
//
//  Created by igor on 8/6/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemToPresent: FeedItem?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let itemToPresent = itemToPresent else {
            handleError()
            return
        }
        presentItem(itemToPresent)
        
    }
    
    //MARK: - Private methods
    
    /**
     Configure UI for the item
     
     - parameter item: Item to present
     */
    private func presentItem(item: FeedItem) {
        titleLabel.text = item.title
        bodyTextView.text = item.body
        DateFormattingUtility.sharedInstance.configureForUsage(UsageCase.PubDate)
        dateLabel.text = DateFormattingUtility.sharedInstance.stringFromDate(item.pubDate!)
    }
    
    /**
     If item is missing for some reason, show alert and back to previous screen
     */
    private func handleError() {
        let okAction = UIAlertAction(title: "OK", style: .Default) { action in
            self.navigationController?.popViewControllerAnimated(true)
        }
        let alertController = AlertsUtility.alertControllerOfType(AlertType.Error,
                                                                  message: Constants.Messages.DetailsErrorMsg,
                                                                  actions: [okAction])
        presentViewController(alertController, animated: true, completion: nil)
    }
}
