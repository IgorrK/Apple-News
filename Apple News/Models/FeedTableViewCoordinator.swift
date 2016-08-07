//
//  FeedTableViewCoordinator.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit
typealias SectionData = (dataSource: [FeedItem], headerData: String)

protocol FeedTableViewCoordinatorDelegate {
    /**
     Called when user has selected a table row
     
     - parameter item: Item in table row
     */
    func feedTableViewCoordinatorDidSelectItem(item: FeedItem)
    
    /**
     Called when user has pulled a refresh control
     */
    func feedTableViewCoordinatorDidRefresh()
}

/// Separate class responsible for interaction with UITableView on Feed screen
final class FeedTableViewCoordinator: NSObject {
    
    // MARK: - Properties
    
    var delegate: FeedTableViewCoordinatorDelegate?
    
    let tableViewDataSource = TableViewDataSource()
    let tableViewDelegate = TableViewDelegate()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            configureTableView()
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        tableViewDelegate.coordinator = self
    }
    
    // MARK: - Private methods
    
    func configureTableView() {
        // Register custom section header
        let headerNib = UINib(nibName: String(FeedTableHeaderView), bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: String(FeedTableHeaderView))
        
        // Set TableView's dataSource and delegate
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Public methods
    
    func reloadData(data: [FeedItem]) {
        let dataSource = FeedTableViewCoordinator.generateDataSourceFromData(data)
        tableViewDataSource.data = dataSource!
        tableViewDelegate.data = dataSource!
        if refreshControl.refreshing == true {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    /**
     Make an array of section titles and row items, grouped by section
     
     - parameter data: Input array
     
     - returns: Full data source for table
     */
    private static func generateDataSourceFromData(data: [FeedItem]) -> [SectionData]? {
        // Configure date formatter for use with table headers
        let dateFormattingUtility = DateFormattingUtility.sharedInstance
        dateFormattingUtility.configureForUsage(UsageCase.TableHeader)
        
        // Data is sorted by date with fetch request, so during
        // traversal we can compare the FeedItem's date only with the
        // previous one and decide whether the item should be added to the previous
        // section or to the new one. Algorithm allows to perform this
        // with O(n) complexity
        var previousDate: NSDate?
        var previousIndex = 0
        var fullDataSource = [SectionData]()
        
        for item in data {
            let pubDateStr = dateFormattingUtility.stringFromDate(item.pubDate!)
            
            if previousDate == nil {
                // Add first section with first item
                previousDate = item.pubDate
                fullDataSource.append(SectionData([item], pubDateStr))
                continue
            }
            
            let dateIsEqualToCurrent = NSCalendar.currentCalendar().isDate(item.pubDate!,
                                                                           equalToDate: previousDate!,
                                                                           toUnitGranularity: .Day)
            if dateIsEqualToCurrent {
                // Add item to the previous section
                let sectionDataItem = fullDataSource[previousIndex].dataSource
                fullDataSource[previousIndex] = SectionData(sectionDataItem + [item], pubDateStr)
            } else {
                // Add new section
                fullDataSource.append(SectionData([item], pubDateStr))
                previousDate = item.pubDate
                previousIndex += 1
            }
        }
        return fullDataSource
    }
    
    // MARK: - UIRefreshControl
    
    func refresh() {
        delegate?.feedTableViewCoordinatorDidRefresh()
    }
}

private extension FeedTableViewCoordinator {
    func handleItemSelected(item: FeedItem) {
        delegate?.feedTableViewCoordinatorDidSelectItem(item)
    }
}

final class TableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    var data = [SectionData]()
    var coordinator: FeedTableViewCoordinator?
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        coordinator?.handleItemSelected(data[indexPath.section].dataSource[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FeedTableViewCell.requiredHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FeedTableHeaderView.requiredHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(FeedTableHeaderView)) as? FeedTableHeaderView
        headerView?.configureWith(data[section].headerData)
        return headerView
    }
}

final class TableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var data = [SectionData]()
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
