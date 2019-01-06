//
//  ActivityViewController+Extension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension ActivityViewController {
    
    func setupViews() {
        view.backgroundColor = .primaryOrange
        
        setupCollectionView()
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.register(ActivityCell.self, forCellWithReuseIdentifier: activityCellId)
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .none
            return formatter
        }()
        
        let todayDate = dateFormatter.string(from: Date()).uppercased()
        
        let headerTextView: UITextView = {
            let textView = UITextView()
            
            textView.backgroundColor = .clear
            
            let attributedText = NSMutableAttributedString(string: "Activity", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: "\n\(todayDate)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            textView.attributedText = attributedText
            
            textView.isEditable = false
            textView.isSelectable = false
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            return textView
        }()
        
        
        view.addSubview(headerTextView)
        view.addSubview(activityCollectionView)
        
        
        NSLayoutConstraint.activate([
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            headerTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            headerTextView.heightAnchor.constraint(equalToConstant: 100),
            
            activityCollectionView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor, constant: 8),
            activityCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            activityCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            activityCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

