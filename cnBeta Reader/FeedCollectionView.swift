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
    func feedCollectionViewDidSelectFeed(feed: Feed);
}

class FeedCollectionView: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    weak var delegate: FeedCollectionViewDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
        fetchRequest.fetchLimit = Constants.FETCH_LIMIT

        let context = CoreDataStack.sharedInstance.context
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc as! NSFetchedResultsController<Feed>
    }()
    
    private lazy var refreshHeader: MJRefreshNormalHeader = {
        let refreshHeader = MJRefreshNormalHeader.init(refreshingBlock: {
            ApiService.sharedInstance.fetchFeed(withURL: Constants.API_URL, completion: { (newFeedsCount) in
                
                DispatchQueue.main.async {
                    self.collectionView.mj_header.endRefreshing()
                    self.makeToast("\(newFeedsCount) new feeds", duration: 1.2, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 80))
                    
                }
            })
        })
        return refreshHeader!
    }()
    
    private lazy var refreshFooter: MJRefreshBackFooter = {
        let refreshFooter = MJRefreshBackFooter.init(refreshingBlock: {
            
            let lastItem = self.collectionView.numberOfItems(inSection: 0)
            self.fetchedResultsController.fetchRequest.fetchLimit += Constants.FETCH_LIMIT

            do {
                try self.fetchedResultsController.performFetch()
                
                if let numberOfObjects = self.fetchedResultsController.sections?[0].numberOfObjects {
                    
                    let newItemCount = numberOfObjects - lastItem
                    
                    if newItemCount != 0 {
                        var indexPaths = [IndexPath]()
                        for i in 1...newItemCount {
                            let indexPath = IndexPath(item: lastItem - 1 + i, section: 0)
                            indexPaths.append(indexPath)
                        }
                
                        self.collectionView.performBatchUpdates({
                            self.collectionView.insertItems(at: indexPaths)
                        }, completion: { (completed) in
                           //
                        })
                    } else {
                        self.makeToast("No more feed", duration: 1.2, position: CGPoint(x: self.collectionView.frame.width / 2.0,y: self.collectionView.frame.height - 100))
                    }
                }
                self.collectionView.mj_footer.endRefreshing()
            } catch let err {
                print(err)
            }
            
            
        })
        return refreshFooter!
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let cellId = "NewFeedCellId"
    
    override func setupViews() {
        
        do {
            try fetchedResultsController.performFetch()
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
        
//        let translation = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
//        
//        if translation.y < 0 && collectionView.contentOffset.y < (collectionView.contentSize.height - collectionView.frame.height) && collectionView.contentOffset.y > collectionView.frame.height {
//            cell.alpha = 0
//            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
//            cell.layer.transform = rotationTransform
//            UIView.animate(withDuration: 0.3, animations: {
//                cell.alpha = 1
//                cell.layer.transform = CATransform3DIdentity
//            })
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedObject = fetchedResultsController.object(at: indexPath)
        delegate?.feedCollectionViewDidSelectFeed(feed: feedObject)
    }
    
    // MARK: CollectionView layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let feed = fetchedResultsController.object(at: indexPath)
        let size = CGSize(width: Constants.SCREEN_WIDTH - 40, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        var estimatedTitleFrame: CGRect = .zero
        if let title = feed.title {
            estimatedTitleFrame = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        }
        
        var estimatedContentFrame: CGRect = .zero
        if let content = feed.contentSnippet {
            estimatedContentFrame = NSString(string: content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        }
        
        return CGSize(width: frame.width,height: estimatedContentFrame.height + estimatedTitleFrame.height + 35)
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
            
            self.collectionView.reloadData()
            
        } catch let err {
            print(err)
        }
    
    }
}
