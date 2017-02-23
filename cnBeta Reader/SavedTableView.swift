//
//  SavedFeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/13/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData
import MJRefresh
import DZNEmptyDataSet

protocol SavedTableViewDelegate:class {
    func savedTableViewDidSelectFeed(_ feed: Feed);
}

class SavedTableView: BaseCell, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: SavedTableViewDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "isSaved == 1", argumentArray: nil)
        //fetchRequest.fetchLimit = Constants.FETCH_LIMIT
        
        let context = CoreDataStack.sharedInstance.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc as! NSFetchedResultsController<Feed>
    }()
    
    fileprivate lazy var refreshHeader: MJRefreshStateHeader = {
        let refreshHeader = MJRefreshStateHeader.init(refreshingBlock: {
            do {
                try self.fetchedResultsController.performFetch()
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.reloadData()
            } catch let err {
                print(err)
            }
        })
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        return refreshHeader!
    }()

    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    fileprivate let cellId = "SavedFeedCellId"
    
    override func setupViews() {
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        super.setupViews()
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.mj_header = refreshHeader
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.register(SavedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedCell
        
        let feed = fetchedResultsController.object(at: indexPath)
        cell.feed = feed;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedObject = fetchedResultsController.object(at: indexPath)
        delegate?.savedTableViewDidSelectFeed(feedObject)
    }
    
    // MARK: CollectionView layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let feed = fetchedResultsController.object(at: indexPath)
        let size = CGSize(width: Constants.SCREEN_WIDTH - 40, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        var estimatedTitleFrame: CGRect = .zero
        if let title = feed.title {
            estimatedTitleFrame = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: Constants.TITLE_FONT_FEED], context: nil)
        }
        
        var estimatedContentFrame: CGRect = .zero
        if let content = feed.contentSnippet {
            estimatedContentFrame = NSString(string: content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: Constants.CONTENT_FONT_FEED], context: nil)
        }
        
        return CGSize(width: frame.width, height: estimatedContentFrame.height + estimatedTitleFrame.height + 30 + 30 + 4 + 12 + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: NSFetchedResultsController delegate
    var blockOperation = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
//            if let indexPath = newIndexPath {
//                collectionView.insertItems(at: [indexPath])
//            }
            collectionView.reloadData()
        } else if type == .update {
            // re configure the cell
        } else if type == .delete {
//            if let indexPath = indexPath {
//                collectionView.deleteItems(at: [indexPath])
//            }
            collectionView.reloadData()
        } else if type == .move {
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
            
            if let newIndexPath = newIndexPath {
                collectionView.insertItems(at: [newIndexPath])
            }
        }
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
   
    }

}

extension SavedTableView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: DZNEmptyDataSetSource
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No saved feed yet, try save some interesting one."
        let attribute = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attribute)
    }
    
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        let attribute = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
//        return NSAttributedString(string: "Hit", attributes: attribute)
//    }
    
    // MARK: DZNEmptyDataSetDelegate
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        print("tap")
//    }
    
}
