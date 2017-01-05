//
//  ApiService.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

typealias fetchFeedCompletion = (Int) -> Void

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchFeed(withURL url: String, completion: @escaping fetchFeedCompletion) {
        
        let url = URL(string: url)
        Alamofire.request(url!).responseJSON { (response) in
            
            switch response.result {
            case .success:
                self.parsingData(data: response.result.value, completion: completion)
            case .failure(let error):
                print(error)
            }
        };
    }
    
    func parsingData(data: Any?, completion: @escaping fetchFeedCompletion) {
        
        let privateContext = CoreDataStack.sharedInstance.privateContext
        
        privateContext.perform { 
                    
            let latestFeedDate: NSDate? = CoreDataStack.sharedInstance.getLatestFeed()?.publishedDate
            var newFeedsCount: Int = 0
            
            if let jsonDictionaries = data as? [String : AnyObject] {
                if let responseData = jsonDictionaries["responseData"] as? [String : AnyObject] {
                    if let feed = responseData["feed"] as? [String : AnyObject] {
                        if let entities = feed["entries"] as? NSArray {
                            for entity in entities {
                                if let object = entity as? [String : AnyObject] {
                                    let dateString = object["publishedDate"] as? String
                                    let date = self.getNSDateFromString(dateString: dateString!)
                                    if latestFeedDate == nil {
                                        let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed", context: privateContext) as! Feed
                                        newFeed.title = object["title"] as? String
                                        newFeed.author = object["author"] as? String
                                        newFeed.publishedDate = date
                                        newFeed.link = object["link"] as? String
                                        newFeed.contentSnippet = object["contentSnippet"] as? String
                                        newFeed.isRead = false
                                        newFeed.isSaved = false
                                        newFeed.sectionIdentifier = self.getSectionIdentifier(date: date!)
                                        
                                        newFeedsCount += 1
                                    } else {
                                        if date?.compare(latestFeedDate as! Date) == .orderedDescending {
                                            let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed", context: privateContext) as! Feed
                                            newFeed.title = object["title"] as? String
                                            newFeed.author = object["author"] as? String
                                            newFeed.publishedDate = date
                                            newFeed.link = object["link"] as? String
                                            newFeed.contentSnippet = object["contentSnippet"] as? String
                                            newFeed.isRead = false
                                            newFeed.isSaved = false
                                            newFeed.sectionIdentifier = self.getSectionIdentifier(date: date!)
                                            
                                            newFeedsCount += 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            CoreDataStack.sharedInstance.save()
            completion(newFeedsCount)
        }
        
     //   DispatchQueue.global(qos: .default).async {
     //  }
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
    
    func getSectionIdentifier(date: NSDate) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: date as Date)
    }
}
