//
//  SavedFeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/13/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

class SavedTableView: BaseCell, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            
            print(fetchedResultsController.sections?[0].numberOfObjects ?? "SAVED nothing")
            
        } catch let err {
            print(err)
        }
        
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
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
