//
//  XMLParser.swift
//  Apple News
//
//  Created by igor on 8/5/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit
import CoreData

typealias FeedItemData = Dictionary<String, String>

protocol XMLParserDelegate {
    func parsingDidSucceed(result: [FeedItemData])
    func parsingDidFail(error: NSError)
}

final class XMLParser: NSObject, NSXMLParserDelegate {
    struct keys {
        static let itemKey = "item"
        static let titleKey = "title"
        static let descriptionKey = "description"
        static let pubDateKey = "pubDate"
    }
    
    private let URLString = "https://developer.apple.com/news/rss/news.rss"
    
    // MARK: - Properties
    
    var delegate: XMLParserDelegate?
    
    private let parser: NSXMLParser
    private var parsedData = [FeedItemData]()
    private var currentData: FeedItemData?
    private var currentElement = String()
    private var foundCharacters = String()
    
    // MARK: - Lifecycle
    
    override init() {
        parser = NSXMLParser(contentsOfURL: NSURL(string: URLString)!)!
        super.init()
        parser.delegate = self
    }
    
    // MARK: - Public methods
    
    func beginParsing() {
        parser.parse()
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        switch elementName {
        case keys.itemKey:
            currentData = FeedItemData()
        default:
            break
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == keys.titleKey ||
            currentElement == keys.descriptionKey ||
            currentElement == keys.pubDateKey {
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case keys.titleKey, keys.descriptionKey, keys.pubDateKey:
            if currentData != nil {
                // remove newline symbol from each element
                let result = foundCharacters.substringFromIndex(foundCharacters.startIndex.advancedBy(1))
                currentData![elementName] = result
            }
              foundCharacters = ""
        case keys.itemKey:
            guard let currentData = currentData else {
                let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Internal parsing error."])
                delegate?.parsingDidFail(error)
                return
            }
            parsedData.append(currentData)
            self.currentData = nil
        default:
            break;
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingDidSucceed(parsedData)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
       delegate?.parsingDidFail(parseError)
    }

    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
       delegate?.parsingDidFail(validationError)
    }
    
}
