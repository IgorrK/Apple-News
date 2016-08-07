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
        // Set labels
        titleLabel.text = item.title
        DateFormattingUtility.sharedInstance.configureForUsage(UsageCase.PubDate)
        dateLabel.text = DateFormattingUtility.sharedInstance.stringFromDate(item.pubDate!)
        
        // Explicit call from main thread is required because NSAttributedString
        // uses WebKit, which is not thread-safe, for import of HTML documents
        dispatch_async(dispatch_get_main_queue(), {
            let attributedOptions: [String : AnyObject] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding
            ]
            let encodedData = item.encodedContent!.dataUsingEncoding(NSUTF8StringEncoding)!

            do {
                let attributedString = try NSMutableAttributedString(data: encodedData,
                    options: attributedOptions,
                    documentAttributes: nil)
                
                // Other attributes cannot be mutated during HTML import,
                // so we have to set them separately
                attributedString.beginEditing()
                attributedString.addAttributes([NSFontAttributeName : UIFont.italicSystemFontOfSize(16.0)], range: NSMakeRange(0, attributedString.length))
                attributedString.endEditing()
                
                self.bodyTextView.attributedText = attributedString
            } catch {
                // Show at least plain text if import from HTML has failed
                self.bodyTextView.text = item.body
                print(error)
            }
        })
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
