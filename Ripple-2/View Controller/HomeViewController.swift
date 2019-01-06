//
//  HomeViewController.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    //-------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Properties
    enum EditorTextViewConstants {
        static let charUpperBound = 140
    }
    
    let homeCellId = "homeId"
    
    // Dependency Data Controller Injection
    var dataController: DataController!
    
    // Fetched Results Controller, specified with an entity
    var fetchedResultsController: NSFetchedResultsController<Gratitude>!
    
    let editorTextView: UITextView = {
        let textView = UITextView()
        textView.text = EditorDefaults.placeholderText
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = .gray
        textView.textAlignment = .left
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.layer.cornerRadius = 8.0
        
        return textView
    }()
    
    
    let hintButton = HomeViewController.setButtonFor(title: "Hints")
    let giveButton = HomeViewController.setButtonFor(title: "Give")
    
    let charCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = String(EditorTextViewConstants.charUpperBound)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .clear
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    //-------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        headerTextView.attributedText = setTextViewAttributedText()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    //----------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    
    @objc func hintTapped() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let hintVC = HintViewController(collectionViewLayout: layout)
        present(hintVC, animated: true, completion: nil)
    }
    
    @objc func giveTapped() {
        
        let checkInVC = CheckInViewController()
        checkInVC.textToSend = editorTextView.text
        checkInVC.dataController = dataController
        show(checkInVC, sender: self)
    }
    
    @objc func textViewTapped() {
        
        var usernameString = "Hi There"
        
        let alert = UIAlertController(title: "Hello, what's your name?", message: "Enter your name to personalize your gifts!", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            guard let unwrappedUsername = alert.textFields?[0].text else { return }
            
            let trimmedString = unwrappedUsername.trimmingCharacters(in: .whitespaces)
            
            if !(trimmedString == "") {
                usernameString = unwrappedUsername
            }
            
            UserDefaults.standard.set(usernameString, forKey: "username")
            self.headerTextView.attributedText = self.setTextViewAttributedText()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //----------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    fileprivate func setGratitudeAttributedString(_ gratitudeCount: Int) -> NSAttributedString {
        
        if gratitudeCount == 1 {
            return NSAttributedString(string: "\nYou have given \(gratitudeCount) gratitude", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            return NSAttributedString(string: "\nYou have given \(gratitudeCount) gratitudes", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    func setTextViewAttributedText() -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString()
        var usernameString = ""
        
        if let unwrappedUserTitle = UserDefaults.standard.string(forKey: "username") {
            usernameString = unwrappedUserTitle
        } else {
            usernameString = "Hi There"
        }
        
        attributedText.append(NSAttributedString(string: usernameString, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        guard let gratitudeCount = fetchedResultsController.fetchedObjects?.count else { return attributedText }
        
        attributedText.append(setGratitudeAttributedString(gratitudeCount))
        
        return attributedText
    }
    
}

// -------------------------------------------------------------------------
// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
    }
}
