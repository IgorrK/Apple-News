//
//  FeedTableViewCoordinator.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit
typealias tableData = (dataSource: [FeedItem], headerData: String)

/// Separate class responsible for interaction with UITableView on Feed screen
final class FeedTableViewCoordinator: NSObject {
    // MARK: - Properties
    
    let tableViewDataSource = TableViewDataSource()
    let tableViewDelegate = TableViewDelegate()
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            configureTableView()
        }
    }
    
    // MARK : - Private methods
    
    func configureTableView() {
        // Register custom section header
        let headerNib = UINib(nibName: String(FeedTableHeaderView), bundle: nil)
        self.tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "id1")
        
        // Set TableView's dataSource and delegate
        self.tableView.dataSource = tableViewDataSource
        self.tableView.delegate = tableViewDelegate
    }
    
    // MARK: - Public methods
    
    func reloadData(data: [AnyObject]) {
        let dataSource = FeedTableViewCoordinator.generateDataSourceFromData(data as! [FeedItem])
        tableViewDataSource.data = dataSource!
//        tableViewDataSource.headersData = FeedTableViewCoordinator.generateHeadersDataWith(data)
        tableViewDelegate.data = dataSource!
        tableView.reloadData()
    }
    
    private static func generateDataSourceFromData(data: [FeedItem]) -> [tableData]? {
        // TODO: handle date formatting somewhere else
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        var currentDay: String?
        var index = 0
        var fullDataSource = [tableData]()

        for item in data {
            let pubDateStr = dateFormatter.stringFromDate(item.pubDate!)
            if currentDay == nil {
                currentDay = pubDateStr
            }
            
            if currentDay == pubDateStr {
                if fullDataSource.count == 0 {
                    fullDataSource.append(tableData([item], pubDateStr))
                    
                } else {
                    let tableDataItem = fullDataSource[index].dataSource
                    fullDataSource[index] = tableData(tableDataItem + [item], pubDateStr)
                }
            } else {
                fullDataSource.append(tableData([item], pubDateStr))
                currentDay = pubDateStr
                index += 1
            }
        }
        
        
        return fullDataSource
    }
}

class TableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    var data = [tableData]()
    private (set) var selectedItem: AnyObject?
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        selectedItem = data[indexPath.section][indexPath.row]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("id1")
//        return headerView
//    }
}

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var data = [tableData]()
    var headersData: Array<String> = [String]()
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].dataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].headerData
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = tableView.dequeueReusableCellWithIdentifier(String(FeedTableViewCell)) as! FeedTableViewCell
        cell.configureWith(data[indexPath.section].dataSource[indexPath.row])
        return cell
    }
}
