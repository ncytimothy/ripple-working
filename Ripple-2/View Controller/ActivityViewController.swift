//
//  ActivityViewController.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController {
    
    //-------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Properties
    let activityCellId = "activityCell"
    var activityCollectionView: UICollectionView!
    
    // Dependency Data Controller Injection
    var dataController: DataController!
    
    // Fetched Results Controller, specified with an entity
    var fetchedResultsController: NSFetchedResultsController<Gratitude>!
    
    enum CollectionViewConstants {
        static let cellsCount: Int = 5
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Fetched Results Controller Setup
    
    fileprivate func setUpFetchedResultsController() {
        // 1. Create Fetch Request
        let fetchRequest: NSFetchRequest<Gratitude> = Gratitude.fetchRequest()
        
        // 2. Configure the fetch request by adding a sort rule
        // fetchRequest.sortDescriptors property takes an array of sort descriptors
        // .sortDescriptors **MUST** be set on any NSFetchedResultsController instance
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 3. Instantiate fetched results controller with fetch request
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "gratitude")
        
        // 4. Set the fetched results controller delegate property to self
        fetchedResultsController.delegate = self
        
        // 5. Perform fetch to load data and start tracking
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch cannot be performed: \(error.localizedDescription)")
        }
        
        // 6. Remove the Fetched Results Controller when the view disappears
        // 7. Implement delegate confromance + methods for fetched results controller for UI updates (in an Extension)
    }
    // -------------------------------------------------------------------------
    
}

// -------------------------------------------------------------------------
// MARK: - NSFetchedResultsControllerDelegate
extension ActivityViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            activityCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            activityCollectionView.deleteItems(at: [indexPath!])
        case .update:
            activityCollectionView.reloadItems(at: [newIndexPath!])
            break
        default:
            break
        }
    }
}
