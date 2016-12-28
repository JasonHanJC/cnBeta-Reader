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

protocol SavedTableViewDelegate:class {
    func savedTableViewDidSelectFeed(feed: Feed);
}

class SavedTableView: BaseCell, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: SavedTableViewDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Feed> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "isSaved == 1", argumentArray: nil)
        //fetchRequest.fetchLimit = Constants.FETCH_LIMIT
        
        let context = CoreDataStack.sharedInstance.context
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc as! NSFetchedResultsController<Feed>
    }()
    
    private lazy var refreshHeader: MJRefreshStateHeader = {
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

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let cellId = "SavedFeedCellId"
    
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
        collectionView.backgroundColor = UIColor(white: 0.90, alpha: 1)
        collectionView.register(SavedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        delegate?.savedTableViewDidSelectFeed(feed: feedObject)
    }
    
    // MARK: CollectionView layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let feed = fetchedResultsController.object(at: indexPath)
        let size = CGSize(width: Constants.SCREEN_WIDTH - 24, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        var estimatedTitleFrame: CGRect = .zero
        if let title = feed.title {
            estimatedTitleFrame = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        }
        
//        var estimatedContentFrame: CGRect = .zero
//        if let content = feed.contentSnippet {
//            estimatedContentFrame = NSString(string: content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
//        }
        
        return CGSize(width: frame.width,height: estimatedTitleFrame.height + 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: NSFetchedResultsController delegate
    var blockOperation = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
            }
        } else if type == .update {
            // re configure the cell
        } else if type == .delete {
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
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
