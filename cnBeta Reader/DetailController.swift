//
//  DetailController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/14/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Ji
import Alamofire
import Toast_Swift

enum ParagraphType: Int {
    case title
    case none
    case image
    case text
    case video
}

struct Paragraph {
    
    var type: ParagraphType?
    var paragraphString: String?
    var paragraphHeight: CGFloat?
    
    init(type: ParagraphType, string: String) {
        self.type = type
        self.paragraphString = string
        if (type == .text) || (type == .title) {
            self.paragraphHeight = computeHeight(string: "        \(string)")
        } else {
            self.paragraphHeight = 250;
        }
    }
    
    private func computeHeight(string: String) -> CGFloat {
        let size = CGSize(width: Constants.SCREEN_WIDTH - 8 - 8, height: CGFloat(FLT_MAX))
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: string).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGFloat(ceilf(Float(estimatedFrame.size.height)) + 10)
    }
}

typealias contentParsingCompletion = ([Paragraph]?) -> Void

class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var URLString: String?
    var webTitle: String?
    
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
            let titleParagraph = Paragraph.init(type: .title, string: title)
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
            
                let jiDoc = Ji(htmlData: cnbetaData)!
            
                let introduceNode = jiDoc.xPath("/html/body/section/section[2]/section/div/div/section[1]/div[1]")
                for intro in (introduceNode?.first?.children)! {
                    if let introContent = intro.content {
                    
                        if introContent == "" {
                            // TODO: show image?
                        } else {
                            let paragraph = Paragraph.init(type: .text, string: introContent)
                            contents.append(paragraph)
                        }
                    }
                }
                
                if let contentNode = jiDoc.xPath("/html/body/section/section[2]/section/div/div/section[1]/div[2]") {
                    for content in (contentNode.first?.children)! {

                        if let contentString = content.content {
                        // image? video?
                            if contentString == "" {

                                if let imageSrc = content.children.first?.children.first?.attributes["src"] {
                                    let paragraph = Paragraph.init(type: .image, string: imageSrc)
                                    contents.append(paragraph)
                                }
                            } else {
                                if contentString.contains("[广告]活动入口") {
                                    break
                                }
                                let paragraph = Paragraph.init(type: .text, string: contentString)
                                contents.append(paragraph)
                            }
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
