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
import Kanna

typealias fetchFeedCompletion = (Int) -> Void

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchFeed(withURL url: String, completion: @escaping fetchFeedCompletion) {
        
        let url = URL(string: url)
        Alamofire.request(url!).responseJSON { (response) in
            
            switch response.result {
            case .success:
                //print(response.result.value ?? "nothing")
                self.parsingData(response.result.value, completion: completion)
            case .failure(let error):
                print(error)
            }
        };
    }
    
    func parsingData(_ data: Any?, completion: @escaping fetchFeedCompletion) {
        
        let privateContext = CoreDataStack.sharedInstance.privateContext
        
        privateContext.perform {
                    
            let latestFeedDate: Date? = CoreDataStack.sharedInstance.getLatestFeed()?.publishedDate
            var newFeedsCount: Int = 0
            
            if let jsonDictionaries = data as? [String : AnyObject] {
                if let items = jsonDictionaries["items"] as? [AnyObject] {
                    for item in items {
                        if item is [String : AnyObject] {
                            let publishDate = item["published"] as? Double
                            let date = self.getNSDateFromTimestamp(publishDate! / 1000.0)
                            if latestFeedDate == nil {
                                let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed", context: privateContext) as! Feed
                                newFeed.id = item["id"] as? String
                                newFeed.title = item["title"] as? String
                                newFeed.author = "cnBeta Reader"
                                newFeed.publishedDate = date
                                newFeed.link = item["originId"] as? String
                                if let summary = item["summary"] as? [String : AnyObject] {
                                    if let content = summary["content"] as? String {
                                        
                                        do {
                                            let doc = try HTML(html: content, encoding: .utf8)
                                            newFeed.contentSnippet = doc.text ?? ""
                                        } catch let err {
                                            print(err.localizedDescription)
                                        }
                                        
                                    }
                                }
                                newFeed.isRead = false
                                newFeed.isSaved = false
                                newFeed.sectionIdentifier = self.getSectionIdentifier(date!)
                                
                                newFeedsCount += 1
                            } else {
                                if date?.compare(latestFeedDate! as Date) == .orderedDescending {
                                    let newFeed = CoreDataStack.sharedInstance.createObjectForEntity("Feed", context: privateContext) as! Feed
                                    newFeed.id = item["id"] as? String
                                    newFeed.title = item["title"] as? String
                                    newFeed.author = "cnBeta Reader"
                                    newFeed.publishedDate = date
                                    newFeed.link = item["originId"] as? String
                                    if let summary = item["summary"] as? [String : AnyObject] {
                                        if let content = summary["content"] as? String {
                                            
                                            do {
                                                let doc = try HTML(html: content, encoding: .utf8)
                                                newFeed.contentSnippet = doc.text ?? ""
                                            } catch let err {
                                                print(err.localizedDescription)
                                            }
                                            
                                        }
                                    }

                                    newFeed.isRead = false
                                    newFeed.isSaved = false
                                    newFeed.sectionIdentifier = self.getSectionIdentifier(date!)
                                
                                    newFeedsCount += 1
                                }
                            }
                        }
                    }
                }
            }
            
            do {
                try CoreDataStack.sharedInstance.privateContext.save()
                
                CoreDataStack.sharedInstance.save()
                
                completion(newFeedsCount)
            } catch let backgroundSaveErr {
                print(backgroundSaveErr.localizedDescription)
            }
            
        }
        
     //   DispatchQueue.global(qos: .default).async {
     //  }
    }
    
    
    fileprivate override init() {
        super.init()
    }
}

extension ApiService {
    
    func getNSDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        if let date = dateFormatter.date(from: dateString) {
            return (date as NSDate) as Date
        }
        return nil
    }
    
    func getSectionIdentifier(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
    func getNSDateFromTimestamp(_ timestamp: Double) -> Date? {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
