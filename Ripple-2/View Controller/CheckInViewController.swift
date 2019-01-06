//
//  CheckInViewController.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class CheckInViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Properties
    
    let cellId = "feelingCell"
    
    var textToSend: String = ""
    
    var feelingsCollectionView: UICollectionView!
    var leadingConstraintForFeelingsCollection: CGFloat = 20
    
    var nextBarButtonItem = UIBarButtonItem()
    
    // DataController property passed from AppeDelegate
    var dataController: DataController!
    
    // Fetched Results Controller
    var fetchedResultsController: NSFetchedResultsController<Feeling>!
    
    let tagButton: UIButton = CheckInViewController.setButtonFor(title: "TAG")
    let cancelButton: UIButton = CheckInViewController.setButtonFor(title: "CANCEL")
    
    
    enum FeelingConstants {
        struct ImageName {
            static let Happy = "happy"
            static let Sad = "sad"
            static let Love = "love"
            static let Worried = "worried"
            static let Angry = "angry"
            static let Joyful = "joyful"
        }
        
        struct FeelingString {
            static let Happy = "Happy"
            static let Sad = "Sad"
            static let Love = "Loved"
            static let Worried = "Worried"
            static let Angry = "Angry"
            static let Joyful = "Joyful"
        }
    }
    
    enum CollectionViewConstants {
        static let cellsCount: Int = 6
    }
    
    var selectedCell = FeelingCell()
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setUpFetchedResultsController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear called")
        if let setFeelingsBefore = UserDefaults.standard.value(forKey: "setFeelingsBefore") as? Bool {
            print("setFeelingsBefore: \(setFeelingsBefore)")
            if setFeelingsBefore == false {
                UserDefaults.standard.set(true, forKey: "setFeelingsBefore")
                setUpFeeings()
            }
        }
        
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Fetched Results Controller Setup
    
    fileprivate func setUpFetchedResultsController() {
        // 1. Create Fetch Request
        let fetchRequest: NSFetchRequest<Feeling> = Feeling.fetchRequest()
        
        // 2. Configure the fetch request by adding a sort rule
        // fetchRequest.sortDescriptors property takes an array of sort descriptors
        // .sortDescriptors **MUST** be set on any NSFetchedResultsController instance
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 3. Instantiate fetched results controller with fetch request
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "feeling")
        
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
    // MARK: - Helpers
    
    fileprivate func setFeeling(imageName: String, feelingString: String) {
        print("setFeeling...")
        //        let feeling = FeelingLive(imageName: imageName, feelingString: feelingString)
        //        feelingsLive.append(feeling)
        
        let feeling = Feeling(context: dataController.viewContext)
        feeling.imageName = imageName
        feeling.feelingString = feelingString
        feeling.creationDate = Date()
        
        do {
            try dataController.viewContext.save()
            
        } catch {
            debugPrint("Cannot save feeling to Core Data")
        }
    }
    
    fileprivate func setUpFeeings() {
        setFeeling(imageName: FeelingConstants.ImageName.Happy, feelingString: FeelingConstants.FeelingString.Happy)
        setFeeling(imageName: FeelingConstants.ImageName.Sad, feelingString: FeelingConstants.FeelingString.Sad)
        setFeeling(imageName: FeelingConstants.ImageName.Love, feelingString: FeelingConstants.FeelingString.Love)
        setFeeling(imageName: FeelingConstants.ImageName.Worried, feelingString: FeelingConstants.FeelingString.Worried)
        setFeeling(imageName: FeelingConstants.ImageName.Angry, feelingString: FeelingConstants.FeelingString.Angry)
        setFeeling(imageName: FeelingConstants.ImageName.Joyful, feelingString: FeelingConstants.FeelingString.Joyful)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    @objc func handleTag() {
        
        if let indexPathForSelectItems = feelingsCollectionView.indexPathsForSelectedItems {
            print("indexPathForSelectItems: \(indexPathForSelectItems)")
            for indexPath in indexPathForSelectItems {
                let selectedCell = feelingsCollectionView.cellForItem(at: indexPath) as! FeelingCell
                guard let feelingText = selectedCell.feeling?.feelingString else { return }
            }
        }
        
        if MFMessageComposeViewController.canSendText() {
            print("SMS services are available")
            
            if let indexPathForSelectItems = feelingsCollectionView.indexPathsForSelectedItems {
                print("indexPathForSelectItems: \(indexPathForSelectItems)")
            }
            
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            
            guard let indexPathForSelectItems = feelingsCollectionView.indexPathsForSelectedItems else { return }
            
            for indexPath in indexPathForSelectItems {
                selectedCell = feelingsCollectionView.cellForItem(at: indexPath) as! FeelingCell
                
                guard let feelingText = selectedCell.feeling?.feelingString else { return }
                
                messageController.body = textToSend + " " + "#Feeling\(feelingText)"
                
                present(messageController, animated: true, completion: nil)
                
            }
            
        } else {
            print("SMS services are not available")
            let alert = UIAlertController(title: "SMS services not availlable", message: "SMS services are not availble on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        print("trying to cancel/dismiss check in vc...")
        dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .sent:
            print("sent")
            
            let gratitude = Gratitude(context: dataController.viewContext)
            gratitude.gratitudeString = textToSend
            gratitude.creationDate = Date()
            gratitude.feeling = selectedCell.feeling
            
            do {
                try dataController.viewContext.save()
                dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            } catch {
                debugPrint("Cannot save gratitude!")
            }
            
            print("gratitude: \(gratitude)")
            
            
            
        case .cancelled:
            print("cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("failed")
        }
        
        
    }
    
    
}

// -------------------------------------------------------------------------
// MARK: - NSFetchedResultsControllerDelegate
extension CheckInViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            feelingsCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            feelingsCollectionView.deleteItems(at: [indexPath!])
        case .update:
            feelingsCollectionView.reloadItems(at: [newIndexPath!])
            break
        default:
            break
        }
    }
}
