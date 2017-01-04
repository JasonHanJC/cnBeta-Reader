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
import CoreData

typealias contentParsingCompletion = ([Paragraph]?) -> Void

class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedFeed: Feed?
    private var URLString: String?
    
    var contentArray: [Paragraph]?
    
    let cellId = "cellId"
    
    let zoomImageController: ZoomImageController = {
        let controller = ZoomImageController()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView?.register(WebCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white

        view.backgroundColor = .white
        
        setupNavigationBar()
        
        contentArray = [Paragraph]()

        // Create title
        if let title = selectedFeed?.title {
            let titleParagraph = Paragraph.init(type: .title, content: title, alignment: .alignmentLeft, textStyle: .strong)
            contentArray?.append(titleParagraph)
        }
        
        if let urlString = selectedFeed?.link?.replacingOccurrences(of: "http://www.cnbeta.com/articles/", with: "http://m.cnbeta.com/view/") {
            
            print(urlString)
            URLString = urlString
            
            if let data = selectedFeed?.savedContent as? Data {
                
                if let content = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Paragraph] {
                    contentArray? += content
                    collectionView?.reloadData()
                }
            } else {
                view.makeToastActivity(.center)
                DispatchQueue.global(qos: .default).async {
                    self.getWebContentWithUrl(urlString: urlString, completion: { contents in
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
        }
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let saveImage = (selectedFeed?.isSaved)! ? "Saved" : "Save"
        let saveButton = UIBarButtonItem(image: UIImage(named: saveImage)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSave))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNavMore))
        
        navigationItem.rightBarButtonItems = [moreButton, saveButton]
    }
    
    func handleSave(sender: UIBarButtonItem) {
        
        if selectedFeed?.isSaved == false {
            view.makeToast("Feed saved", duration: 0.5, position: CGPoint(x: (self.collectionView?.frame.width)! / 2.0,y: (self.collectionView?.frame.height)! - 80))
            sender.image = UIImage(named: "Saved")?.withRenderingMode(.alwaysOriginal)
        } else {
            view.makeToast("Feed unsaved", duration: 0.5, position: CGPoint(x: (self.collectionView?.frame.width)! / 2.0,y: (self.collectionView?.frame.height)! - 80))
            sender.image = UIImage(named: "Save")?.withRenderingMode(.alwaysOriginal)
        }
        
        selectedFeed?.isSaved = !(selectedFeed?.isSaved)!
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func handleNavMore(sender: UIBarButtonItem) {
        view.makeToast("Nothing in here yet", duration: 1.2, position: CGPoint(x: (self.collectionView?.frame.width)! / 2.0,y: (self.collectionView?.frame.height)! - 80))
        
        // TODO: open in browser and share
        //UIApplication.shared.openURL(URL(string: (selectedFeed?.link)!)!)
    }
    
    
    // MARK: Collection View Delegate and Data source
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let paragragh = contentArray?[indexPath.item]
        if paragragh?.type == .image {
            zoomImageController.imageView.loadImageWithURLString(urlString: paragragh?.paragraphString, completion: {_ in })
            zoomImageController.show()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = contentArray?[indexPath.item].paragraphHeight
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(height!))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getWebContentWithUrl(urlString: String, completion: @escaping contentParsingCompletion) {
        
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
                
                let data = NSKeyedArchiver.archivedData(withRootObject: contents)
                self.selectedFeed?.savedContent = data as NSData
                
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
