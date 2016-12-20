//
//  DetailController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/14/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import Kanna

typealias contentParsingCompletion = ([Paragraph]?) -> Void

class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var URLString: String?
    var webTitle: String?
    //var timeString: String?
    
    var contentArray: [Paragraph]?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(WebCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        view.backgroundColor = .white
        
        contentArray = [Paragraph]()
        // Create title
        if let title = webTitle {
            let titleParagraph = Paragraph.init(type: .title, content: title, alignment: .alignmentLeft, textStyle: .strong)
            contentArray?.append(titleParagraph)
        }
        
        if let urlString = URLString {
            
            view.makeToastActivity(.center)
                
            getWebContentWithUrl(urlString: urlString, completion: { contents in
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    
                    if let newFeeds = contents {
                        self.contentArray? += newFeeds
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WebCell
        
        cell.paragraph = contentArray?[indexPath.item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = contentArray?[indexPath.item].paragraphHeight
        
        return CGSize(width: collectionView.frame.width, height: height!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getWebContentWithUrl(urlString: String, completion: @escaping contentParsingCompletion) {
        
        DispatchQueue.global(qos: .default).async {
            
            let url = URL(string: urlString);
            let cnbetaData = try? Data(contentsOf: url!)
            
            if let cnbetaData = cnbetaData {
                
                var contents = [Paragraph]()
                
                
                if let doc = HTML(html: cnbetaData, encoding: .utf8) {
                    
                    // article sum
                    for link in doc.css("div.article-summ") {
                        if link.text != "" {
                            let paragraph = Paragraph.init(type: .summary, content: link.text!, alignment: .alignmentLeft,  textStyle: .normal)
                            contents.append(paragraph)

                        }
                    }

                    // article content
                    for link in doc.css("div.articleCont p") {
                        
                        if link.text == "" {
                            // image or video
                            for imageNode in link.css("img") {
                                if let imageSrc = imageNode["src"] {
                                    let paragraph = Paragraph.init(type: .image, content: imageSrc, alignment: .alignmentCenter)
                                    contents.append(paragraph)
                                }
                            }
                            
                        } else {
                            
                            var textStyle: TextStyle = .normal
                            if link.css("strong").first?.text != nil {
                                textStyle = .strong
                            }
                            
                            var textAlignment: ParagraphAlignment = .alignmentLeft
                            if link["style"] == "text-align: center;" {
                                textAlignment = .alignmentCenter
                            } else if link["style"] == "text-align: right;"{
                                textAlignment = .alignmentRight
                            }
                            
                            let paragraph = Paragraph.init(type: .text, content: link.text!, alignment: textAlignment,  textStyle: textStyle)
                            contents.append(paragraph)
                            
                        }
                    }
                }
                
                if self.URLString == urlString {
                    completion(contents)
                }
            } else {
                print("The url is inaccessible")
                if self.URLString == urlString {
                    completion(nil)
                }
            }
        }
    }
}
