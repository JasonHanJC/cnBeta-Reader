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
                                            if let appDelegete = UIApplication.shared.delegate as? AppDelegate {
                                                let newFeed = NSEntityDescription.insertNewObject(forEntityName: "Feed", into: appDelegete.managedContext!) as! Feed
                                                newFeed.title = object["title"] as? String
                                                
                                                let dateString = object["publishedDate"] as? String
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
                                                if let date = dateFormatter.date(from: dateString!) {
                                                    newFeed.publishedDate = date as NSDate
                                                }
                                                newFeed.contentSnippet = object["contentSnippet"] as? String
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                var feeds = [Feed]()
                
                do {
                    
                    try (UIApplication.shared.delegate as? AppDelegate)?.managedContext?.save()
                    
                    let feedFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
                    feedFetch.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
                    feedFetch.fetchLimit = 50
                    feeds = try (UIApplication.shared.delegate as? AppDelegate)?.managedContext?.fetch(feedFetch) as! [Feed]

                    completion(feeds)
                    
                } catch let error as NSError {
                    print("Error: \(error) " +
                        "description \(error.localizedDescription)")
                }

                
            } catch let jsonError {
                print(jsonError)
            }
        }).resume()

    }
    
    
    private override init() {
        super.init()
    }
    
}
