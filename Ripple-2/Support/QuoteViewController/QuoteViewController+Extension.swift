//
//  QuoteViewController+Extension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension QuoteViewController {
    
    func setupViews() {
        view.backgroundColor = .primaryOrange
        
        
        setupCollectionView()
        quoteCollectionView.delegate = self
        quoteCollectionView.dataSource  = self
        quoteCollectionView.register(QuoteCell.self, forCellWithReuseIdentifier: quoteCellId)
        
        
        let headerTextView: UITextView = {
            let textView = UITextView()
            
            textView.backgroundColor = .clear
            
            let attributedText = NSMutableAttributedString(string: "Quotes of the Day", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: "\nGet inspired!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            textView.attributedText = attributedText
            
            textView.isEditable = false
            textView.isSelectable = false
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            return textView
        }()
        
        view.addSubview(headerTextView)
        view.addSubview(refreshButton)
        view.addSubview(quoteCollectionView)
        
        NSLayoutConstraint.activate([
            
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            headerTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            headerTextView.heightAnchor.constraint(equalToConstant: 100),
            
            refreshButton.topAnchor.constraint(equalTo: headerTextView.bottomAnchor),
            refreshButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            
            quoteCollectionView.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 8),
            quoteCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            quoteCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            quoteCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            
            ])
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static func setButtonFor(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.primaryOrange, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

