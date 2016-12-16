//
//  DetailController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/14/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Ji

enum ContentType: Int {
    case image
    case text
    case video
}

class DetailController: UIViewController, UIWebViewDelegate {
    
    var URLString: String?
    
    var contentIndexDic: [Int : String]?
    var contentTypeDic: [String : ContentType]?
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: self.view.bounds)
        webView.scalesPageToFit = true
        webView.stringByEvaluatingJavaScript(from: "document.body.style.zoom = 1.5;")
        webView.delegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Do any additional setup after loading the view.
        self.view.addSubview(webView)
        webView.scalesPageToFit = true
        
        let url = Bundle.main.url(forResource: "test", withExtension: "html")
        
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        
        if URLString != nil {
            
            let url = URL(string: URLString!);
            
            
            let cnbetaData = try? Data(contentsOf: url!)
            if let cnbetaData = cnbetaData {
                
                contentIndexDic = Dictionary()
                contentTypeDic = Dictionary()
                
                var index: Int = 0
                
                let jiDoc = Ji(htmlData: cnbetaData)!
                let htmlNode = jiDoc.rootNode!
                print("html tagName: \(htmlNode.tagName)") // html tagName: Optional("html")
                
                let introduceNode = jiDoc.xPath("/html/body/section/section[2]/section/div/div/section[1]/div[1]")
                print(introduceNode ?? "")
                
                let contentNode = jiDoc.xPath("/html/body/section/section[2]/section/div/div/section[1]/div[2]")
                print(contentNode ?? "")
                
                
                for content in (contentNode?.first?.children)! {
                    index += 1
                    
                    print("content \(index): \(content)")
                    print("content \(index): \(content.attributes)")
                    print("content \(index): \(content.content)")
                    print("content \(index): \(content.children)")
                    
                    if content.content == "" {
                
                        
                        let subContent = content.children.first
                        print(subContent?.children.first?.attributes["src"] ?? "")
                    }
                    
                }
                
            } else {
                
                print("The url is inaccessible")
            }
            
        }
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
