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
    /**
     Called when XML parser has finished parsing
     
     - parameter result: Array of items, represented in dictionaries
     */
    func parsingDidSucceed(result: [FeedItemData])
    
    /**
     Called when XML parser has encountered an error
     
     - parameter error: Error object
     */
    func parsingDidFail(error: NSError)
}

final class XMLParser: NSObject, NSXMLParserDelegate {
    
    struct keys {
        static let item = "item"
        static let title = "title"
        static let description = "description"
        static let pubDate = "pubDate"
        static let encodedContent = "content:encoded"
    }
    
    // MARK: - Properties

    private let URLString = "https://developer.apple.com/news/rss/news.rss"
    
    var delegate: XMLParserDelegate?
    
    private var parser: NSXMLParser?
    private var parsedData = [FeedItemData]()
    private var currentData: FeedItemData?
    private var currentElement = String()
    private var foundCharacters = String()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    // MARK: - Public methods
    
    func beginParsing() {
        // Clear properties
        parsedData = [FeedItemData]()
        currentData = nil
        currentElement = String()
        foundCharacters = String()
        
        // Init NSXMLParser and begin parsing
        parser = NSXMLParser(contentsOfURL: NSURL(string: URLString)!)!
        parser!.delegate = self
        parser!.parse()
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName
        qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        switch elementName {
        case keys.item:
            currentData = FeedItemData()
        default:
            break
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == keys.title ||
            currentElement == keys.description ||
            currentElement == keys.pubDate ||
            currentElement == keys.encodedContent {
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case keys.title, keys.description, keys.pubDate, keys.encodedContent:
            if currentData != nil {
                // remove newline symbols from each element
                let result = foundCharacters.stringByReplacingOccurrencesOfString("\n", withString: "")
                currentData![elementName] = result
            }
            foundCharacters = ""
        case keys.item:
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
