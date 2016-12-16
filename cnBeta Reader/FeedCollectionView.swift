//
//  FeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift
import MJRefresh

protocol FeedCollectionViewDelegate:class {
    func feedCollectionViewDidSelectFeed(withLink link:String);
}

class FeedCollectionView: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    weak var delegate: FeedCollectionViewDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
        let context = CoreDataStack.sharedInstance.context
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc as! NSFetchedResultsController<Feed>
    }()
    
    lazy var refreshHeader: MJRefreshNormalHeader = {
        let refreshHeader = MJRefreshNormalHeader.init(refreshingBlock: {
            ApiService.sharedInstance.fetchFeed(withURL: "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.cnbeta.com/rss&num=100", completion: { (newFeedsCount) in
                
                DispatchQueue.main.async {
                    self.collectionView.mj_header.endRefreshing()
                    self.makeToast("\(newFeedsCount) new feeds", duration: 1.2, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 100))
                    
                }
            })
        })
        return refreshHeader!
    }()
    
    lazy var refreshFooter: MJRefreshAutoFooter = {
        let refreshFooter = MJRefreshAutoFooter.init(refreshingBlock: {
            self.makeToast("No more feed", duration: 1.2, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 100))
            self.collectionView.mj_footer.endRefreshing()
        })
        return refreshFooter!
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    override func setupViews() {
        
        do {
            try fetchedResultsController.performFetch()
            
            print(fetchedResultsController.sections?[0].numberOfObjects ?? "nothing")
            
        } catch let err {
            print(err)
        }
        
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.mj_header = refreshHeader
        collectionView.mj_footer = refreshFooter
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        let feed = fetchedResultsController.object(at: indexPath) 
        cell.feed = feed;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let translation = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        
        if translation.y < 0 && collectionView.contentOffset.y < (collectionView.contentSize.height - collectionView.frame.height) && collectionView.contentOffset.y > collectionView.frame.height {
            cell.alpha = 0
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
            cell.layer.transform = rotationTransform
            UIView.animate(withDuration: 0.3, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        let feed = fetchedResultsController.object(at: indexPath)
        if let link = feed.link {
            print("selected")
            delegate?.feedCollectionViewDidSelectFeed(withLink: link)
        }
    }
    
    // MARK: CollectionView layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let feed = fetchedResultsController.object(at: indexPath)
        let size = CGSize(width: 281, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: feed.contentSnippet!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        
        return CGSize(width: frame.width,height: estimatedFrame.height + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: NSFetchedResultsController delegate
    var blockOperation = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        if type == .insert {
//            blockOperation.append(BlockOperation(block: {
//                UIView.animate(withDuration: 1, animations: {
//                    self.collectionView.insertItems(at: [newIndexPath!])
//                    print(newIndexPath!)
//                })
//            }))
//        } else if type == .update {
//            
//        } else if type == .delete {
//            
//        } else if type == .move {
//            
//        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.performBatchUpdates({ 
//            for operation in self.blockOperation {
//                operation.start()
//            }
//        }, completion: { (completed) in
//            
//            
//        })
        
        do {
            try fetchedResultsController.performFetch()
            
            collectionView.reloadData()
            
        } catch let err {
            print(err)
        }
    
    }
}
