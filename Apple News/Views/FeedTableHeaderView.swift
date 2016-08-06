//
//  FeedTableHeaderView.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FeedTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!

    static let requiredHeight: CGFloat = 40.0

    // MARK: - Lifecycle
    
    override func drawRect(rect: CGRect) {
        // Correct way to setup header's backgrond color
        self.backgroundView?.backgroundColor = UIColor(red: 0.0704, green: 0.3298, blue: 0.5896, alpha: 1.0)
    }
    
    // MARK: - Public methods
    
    /**
     Configure header title with string
     
     - parameter data: New header title
     */
    func configureWith(data: AnyObject) {
        titleLabel.text = data as? String
    }
}
