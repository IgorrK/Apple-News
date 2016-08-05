//
//  FeedTableViewCell.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    var data: AnyObject?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - UITableViewCell
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Public methods
    
    /**
     Configure the cell with RSS news item
     
     - parameter data: News item
     */
    func configureWith(data: FeedItem) {
        self.data = data
        headerLabel.text = data.title
        bodyLabel.text = data.body
        dateLabel.text = "dte"
    }
}
