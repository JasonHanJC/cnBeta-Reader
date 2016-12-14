//
//  ApiService.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

typealias fetchFeedCompletion = ([Feed]) -> Void

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchFeed(withURL url: String, completion: @escaping fetchFeedCompletion) {

        let latestFeedDate = CoreDataStack.sharedInstance.getLatestFeed()?.publishedDate
        
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                if let unwrappedData = data {
                    if let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String : AnyObject] {
                        if let responseData = jsonDictionaries["responseData"] as? [String : AnyObject] {
                            if let feed = responseData["feed"] as? [String : AnyObject] {
                                if let entities = feed["entries"] as? NSArray {
                                    for entity in entities {
                                        if let object = entity as? [String : AnyObject] {
                                            let dateString = object["publishedDate"] as? String
                                            let date = self.getNSDateFromString(dateString: dateString!)
                                            if latestFeedDate == nil {
                                                let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed") as! Feed
                                                newFeed.title = object["title"] as? String
                                                newFeed.author = object["author"] as? String
                                                newFeed.publishedDate = date
                                                newFeed.link = object["link"] as? String
                                                newFeed.contentSnippet = object["contentSnippet"] as? String
                                                newFeed.isRead = false
                                                newFeed.isSaved = false
                                            } else {
                                                if date?.compare(latestFeedDate as! Date) == .orderedDescending {
                                                    let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed") as! Feed
                                                    newFeed.title = object["title"] as? String
                                                    newFeed.author = object["author"] as? String
                                                    newFeed.publishedDate = date
                                                    newFeed.link = object["link"] as? String
                                                    newFeed.contentSnippet = object["contentSnippet"] as? String
                                                    newFeed.isRead = false
                                                    newFeed.isSaved = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                var feeds = [Feed]()
                feeds = CoreDataStack.sharedInstance.getObjectsForEntity("Feed", sortByKey: "publishedDate", isAscending: false, withPredicate: nil, limit: 0) as! [Feed]
                completion(feeds)
                
            } catch let jsonError {
                print(jsonError)
            }
        }).resume()

    }
    
    private override init() {
        super.init()
    }
    
}


extension ApiService {
    
    func getNSDateFromString(dateString: String) -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        if let date = dateFormatter.date(from: dateString) {
            return date as NSDate
        }
        return nil
    }
    
}
