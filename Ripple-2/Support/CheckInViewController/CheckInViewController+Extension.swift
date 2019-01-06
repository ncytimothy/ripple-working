//
//  CheckInViewController+Extension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

// Views Setup
extension CheckInViewController {
    
    func setupViews() {
        
        view.backgroundColor = UIColor.primaryOrange
        
        tagButton.isEnabled = false
        tagButton.alpha = 0.5
        
        cancelButton.setTitleColor(.gray, for: .normal)
        
        setupCollectionView()
        
        feelingsCollectionView.delegate = self
        feelingsCollectionView.dataSource = self
        feelingsCollectionView.register(FeelingCell.self, forCellWithReuseIdentifier: cellId)
        
        let headerTextView: UITextView = {
            let textView = UITextView()
            
            textView.backgroundColor = .clear
            
            let attributedText = NSMutableAttributedString(string: "Tag a feeling", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: "\nTag a feeling to your message", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            textView.attributedText = attributedText
            
            textView.isEditable = false
            textView.isSelectable = false
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            return textView
        }()
        
        let topTitleTextView: UITextView = {
            let textView = UITextView()
            
            textView.backgroundColor = UIColor.primaryOrange
            
            let attributedText = NSMutableAttributedString(string: "Check-in", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.black])
            
            attributedText.append(NSAttributedString(string: "\nHow are you feeling now?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            textView.attributedText = attributedText
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            textView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
            
            return textView
        }()
        
        let headerContainerView: UIView = {
            let containterView = UIView()
            containterView.translatesAutoresizingMaskIntoConstraints = false
            return containterView
        }()
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [cancelButton, tagButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomControlsStackView.distribution = .fillEqually
        
        
        
        
        tagButton.addTarget(self, action: #selector(handleTag), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        view.addSubview(feelingsCollectionView)
        view.addSubview(headerTextView)
        view.addSubview(bottomControlsStackView)
        
        
        
        NSLayoutConstraint.activate([
            
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            headerTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            feelingsCollectionView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor),
            feelingsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForFeelingsCollection),
            feelingsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingConstraintForFeelingsCollection),
            feelingsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            
            ])
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static func setButtonFor(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func updateSelectUI(cell: FeelingCell) {
        
        if cell.isSelected {
            if  cell.colorOverlay.alpha == 0.0 {
                animateSelectOverlay(cell)
                tagButton.alpha = 1.0
                tagButton.isEnabled = true
            } else {
                animateDeselectOverlay(cell)
                tagButton.alpha = 0.5
                tagButton.isEnabled = false
            }
        }
        
        if !cell.isSelected && cell.colorOverlay.alpha != 0.0 {
            animateDeselectOverlay(cell)
        }
        
    }
    
    fileprivate func animateSelectOverlay(_ cell: FeelingCell) {
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options:                     [.curveEaseIn, .curveEaseOut], animations: {
            cell.colorOverlay.alpha = 0.68
            cell.colorOverlay.bounds.size.height -= 20
            cell.colorOverlay.bounds.size.width -= 20
        }, completion: nil
        )
    }
    
    
    fileprivate func animateDeselectOverlay(_ cell: FeelingCell) {
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.curveEaseIn, .curveEaseOut], animations: {
            cell.colorOverlay.bounds.size.height += 20
            cell.colorOverlay.bounds.size.width += 20
            cell.colorOverlay.alpha = 0.0
        }, completion: nil
        )
    }
    
}
