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
import Kingfisher

typealias contentParsingCompletion = ([Paragraph]?) -> Void

class DetailController: UIViewController {
    
    var activity: NSUserActivity?
    private let activityType: String = "com.juncheng.app.cnBetaReader.OpenWebPage"
    
    let selectedFeed: Feed
    private var URLString: String?
    private var timeLabelText: String?
    
    private var updateImageURL: String = ""
    private var heightDic: [Int : CGFloat] = Dictionary()
    
    private var contentArray: [Paragraph]?
    private var allImageParagraphs: [Paragraph]?
    
    private let titleCellId = "titleCellId"
    private let textCellId = "textCellId"
    private let summCellId = "summCellId"
    private let imageCellId = "imageCellId"
    private let emptyCellId = "emptyCellId"
    
    let imageDisplayController: ImageDisplayController = {
        let controller = ImageDisplayController()
        return controller
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(with selectedFeed: Feed) {
        self.selectedFeed = selectedFeed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        
        contentArray = [Paragraph]()
        allImageParagraphs = [Paragraph]()
        
        if let date = selectedFeed.publishedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM-dd-yyyy HH:mm"
            timeLabelText = dateFormatter.string(from: date as Date)
        }

        // Create title
        if let title = selectedFeed.title {
            // print(title)
            let titleParagraph = Paragraph.init(type: .title, content: title, alignment: .alignmentLeft, textStyle: .strong)
            contentArray?.append(titleParagraph)
        }
        
        // setup activity
        self.activity = NSUserActivity(activityType: activityType)
        self.activity?.webpageURL = URL(string:(selectedFeed.link)!)
        self.activity?.title = "webView"
        self.activity?.isEligibleForHandoff = true
        self.activity?.becomeCurrent()
        
        print(selectedFeed.link ?? "")
        
        if let link = selectedFeed.link {
            
            let index = link.index(link.endIndex, offsetBy: -10)
            let last10 = String(link[index...])
        
            let urlString = "http://m.cnbeta.com/view/\(last10)"
        
            print(urlString)
            URLString = urlString
            
            if let data = selectedFeed.savedContent as Data? {
                
                if let content = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Paragraph] {
                    contentArray? += content
                    collectionView.reloadData()
                    
                    self.getAllImageParagraphs(self.contentArray)
                }
            } else {
                view.makeToastActivity(.center)
                DispatchQueue.global(qos: .default).async {
                    self.getWebContentWithUrl(urlString, completion: { contents in
                        DispatchQueue.main.async {
                            self.view.hideToastActivity()
                        
                            if let newFeeds = contents {
                                self.contentArray? += newFeeds
                                self.collectionView.reloadData()
                                
                                self.getAllImageParagraphs(self.contentArray)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.activity?.invalidate()
    }
    
    deinit {
        print("DetailController deinit")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func getAllImageParagraphs(_ allContents: [Paragraph]?) {
        if let allContents = allContents {
            for paragraph in allContents {
                if paragraph.type == .image {
                    allImageParagraphs?.append(paragraph)
                }
            }
        }
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        if #available(iOS 11.0, *) {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
        
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: textCellId)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView.register(SummCell.self, forCellWithReuseIdentifier: summCellId)
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: emptyCellId)
        collectionView.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        
        let myLogoView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = myLogoView
        
        let backButton = UIBarButtonItem(image: UIImage(named: "nav_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNavBack))
//        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        fixedSpace.width = -8
        
        let saveImage = selectedFeed.isSaved ? "Saved" : "Save"
        let saveButton = UIBarButtonItem(image: UIImage(named: saveImage), style: .plain, target: self, action: #selector(handleSave))
        saveButton.tintColor = Constants.All_ICONS_COLOR
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .plain, target: self, action: #selector(handleNavMore))
        moreButton.tintColor = Constants.All_ICONS_COLOR
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [moreButton, saveButton]
    }
    
    @objc func handleSave(_ sender: UIBarButtonItem) {
        
        if selectedFeed.isSaved == false {
            view.makeToast("Feed saved", duration: 0.5, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 80))
            sender.image = UIImage(named: "Saved")?.withRenderingMode(.alwaysOriginal)
        } else {
            view.makeToast("Feed unsaved", duration: 0.5, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 80))
            sender.image = UIImage(named: "Save")?.withRenderingMode(.alwaysOriginal)
        }
        
        selectedFeed.isSaved = !selectedFeed.isSaved
        CoreDataStack.sharedInstance.save()
    }
    
    @objc func handleNavBack(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNavMore(_ sender: UIBarButtonItem) {
        
        let openInBrowserSetting = Setting(name: .openInBrowser, imageName: "Open in browser")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openInBrowserAction = UIAlertAction(title: openInBrowserSetting.name.rawValue, style: .default) { (action) in
            // TODO: CHECK THE SETTING FOR DEFAULT BROWSER
            if let title = action.title, title == SettingNames.openInBrowser.rawValue {
                if OpenInChromeController.sharedInstance().isChromeInstalled() {
                    OpenInChromeController.sharedInstance().open(inChrome: URL(string: (self.selectedFeed.link)!)!)
                } else {
                    UIApplication.shared.openURL(URL(string: (self.selectedFeed.link)!)!)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(openInBrowserAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWebContentWithUrl(_ urlString: String, completion: @escaping contentParsingCompletion) {
        
        
        let url = URL(string: urlString);
        
        let cnbetaData = try? Data(contentsOf: url!)
            
        if let cnbetaData = cnbetaData {
                
            var contents = [Paragraph]()
                
            do {
                let doc = try HTML(html: cnbetaData, encoding: .utf8)
                // article sum
                for link in doc.css("div.article-summ") {
                    
                    if link.text != "" {
                        let paragraph = Paragraph.init(type: .summary, content: link.text!, alignment: .alignmentLeft,  textStyle: .normal)
                        contents.append(paragraph)
                        
                    }
                }
                
                // article content
                for link in doc.css("div.articleCont p") {
                    
                    let text = link.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if text == "" {
                        // image or video
                        // print("image")
                        for imageNode in link.css("img") {
                            if let imageSrc = imageNode["src"] {
                                //print(imageSrc)
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
                        
                        let paragraph = Paragraph.init(type: .text, content: text!, alignment: textAlignment,  textStyle: textStyle)
                        
                        contents.append(paragraph)
                    }
                }
            } catch let err {
                print(err.localizedDescription)
            }
            
                
            let data = NSKeyedArchiver.archivedData(withRootObject: contents)
            self.selectedFeed.savedContent = data
                
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

extension DetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View Delegate and Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (contentArray?.count ?? 1) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath)
            cell.backgroundColor = .white
            return cell
        }
        
        let currentParagragh = contentArray?[indexPath.item]
        if currentParagragh?.type == .title {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! TitleCell
            
            cell.paragraph = contentArray?[indexPath.item]
            cell.timeLabel.text = timeLabelText
            
            return cell
        } else if currentParagragh?.type == .summary {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: summCellId, for: indexPath) as! SummCell
            
            cell.paragraph = contentArray?[indexPath.item]
            return cell
        } else if currentParagragh?.type == .text {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textCellId, for: indexPath) as! TextCell
            
            cell.paragraph = contentArray?[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! DetailImageCell
            
            let imageURLString = currentParagragh?.paragraphString
            let resource = ImageResource(downloadURL: URL(string: imageURLString!)!, cacheKey: imageURLString)
           
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { [weak self] (image, error, cacheType, imageURL) in
                guard let strongSeft = self else { return }
                if error != nil {
                    // print(error.debugDescription)
                    cell.imageView.image = UIImage(named: "image_broken")
                } else {
                    // update the imageCell
                    if strongSeft.heightDic[indexPath.item] == nil {
                        if let image = image {
                            strongSeft.heightDic[indexPath.item] = (strongSeft.collectionView.frame.width - 24 - 24) / image.size.width * image.size.height + 24
                        }
                        if let URLString = imageURL?.absoluteString {
                            if URLString == imageURLString {
                                //print("The strings are the same")
                                UIView.animate(withDuration: 0, animations: {
                                    strongSeft.collectionView.reloadItems(at: [indexPath])
                                })
                            }
                        }
                    }
                }
            })
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item != collectionView.numberOfItems(inSection: 0) - 1 {
//            let currentParagragh = contentArray?[indexPath.item]
//            if currentParagragh?.type == .image {
//                let cell = cell as! DetailImageCell
//                cell.imageView.kf.cancelDownloadTask()
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentParagragh = contentArray?[indexPath.item]
        if currentParagragh?.type == .image {
            // get all images paragraph
            var imageIndex: Int = 0
            for imageParagraph in allImageParagraphs! {
                if imageParagraph == currentParagragh {
                    break
                }
                imageIndex += 1
            }
            
            let imagePresentController = ImagePresentViewController(with: (allImageParagraphs!, imageIndex))
            navigationController?.pushViewController(imagePresentController, animated: true)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            return CGSize(width: collectionView.frame.width, height:24)
        }
        
        let paragraph = contentArray?[indexPath.item]
        if heightDic[indexPath.item] == nil {
            
            let size = CGSize(width: Constants.SCREEN_WIDTH - 24 - 24, height: CGFloat(CGFloat.greatestFiniteMagnitude))
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedContentFrame: CGRect = .zero
            
            if paragraph?.type == .title { // title cell
                
                if let text = paragraph?.paragraphString {
                    estimatedContentFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: Constants.DETAIL_TITLE_STYLE, context: nil)
                }
                
                heightDic[indexPath.item] =  30 + estimatedContentFrame.height + 6 + 16
            } else if paragraph?.type == .summary || paragraph?.type == .text { // text cell
                
                if let text = paragraph?.paragraphString {
                    estimatedContentFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: Constants.DETAIL_NORMAL_STYLE, context: nil)
                }
                
                heightDic[indexPath.item] = estimatedContentFrame.height + 36
            } else { // image cell
                return CGSize(width: collectionView.frame.width, height: 50)
            }
        }
        
        return CGSize(width: collectionView.frame.width, height: heightDic[indexPath.item]!)
    }
}
