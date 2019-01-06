//
//  HomeViewController+Extension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension HomeViewController: UITextViewDelegate {
    
    func setupViews() {
        view.backgroundColor = .primaryOrange
        
        
        
        disableButton(button: giveButton)
        
        UserDefaults.standard.set(0, forKey: "testNum")
        
        //        testUserLabel.text = String(getValueFromDefaults(key: "testNum") as! Int)
        let tap = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        headerTextView.addGestureRecognizer(tap)
        
        //        setupCollectionView()
        //        homeCollectionView.delegate = self
        //        homeCollectionView.dataSource = self
        //        homeCollectionView.register(HomeCell.self, forCellWithReuseIdentifier: homeCellId)
        
        editorTextView.delegate = self
        
        
        let safeCircleLabel: UILabel = {
            let label = UILabel()
            label.text = "Safe Circle"
            label.font = UIFont.boldSystemFont(ofSize: 21)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white
            return label
        }()
        
        let dividerLineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        hintButton.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        giveButton.addTarget(self, action: #selector(giveTapped), for: .touchUpInside)
        
        view.addSubview(headerTextView)
        view.addSubview(hintButton)
        view.addSubview(giveButton)
        view.addSubview(editorTextView)
        view.addSubview(giveButton)
        view.addSubview(charCountLabel)
        
        NSLayoutConstraint.activate([
            
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            headerTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            headerTextView.heightAnchor.constraint(equalToConstant: 100),
            
            giveButton.topAnchor.constraint(equalTo: headerTextView.bottomAnchor),
            giveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            giveButton.widthAnchor.constraint(equalToConstant: 85),
            giveButton.heightAnchor.constraint(equalToConstant: 30),
            
            hintButton.topAnchor.constraint(equalTo: headerTextView.bottomAnchor),
            hintButton.trailingAnchor.constraint(equalTo: giveButton.leadingAnchor, constant: -10),
            hintButton.widthAnchor.constraint(equalToConstant: 60),
            hintButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            editorTextView.topAnchor.constraint(equalTo: hintButton.bottomAnchor, constant: 14),
            editorTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            editorTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            editorTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            charCountLabel.topAnchor.constraint(equalTo: editorTextView.bottomAnchor, constant: 8),
            charCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
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
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = ""
            textView.textColor = .black
            enableButton(button: giveButton)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText || textView.text == EditorDefaults.placeholderText {
            replaceTextViewPlaceholder()
            disableButton(button: giveButton)
            charCountLabel.text = String(EditorTextViewConstants.charUpperBound)
        }
    }
    
    func replaceTextViewPlaceholder() {
        editorTextView.text = EditorDefaults.placeholderText
        editorTextView.textColor = .gray
        
    }
    
    func configureTapGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func enableButton(button: UIButton) {
        button.isEnabled = true
        UIView.animate(withDuration: 0.05) {
            button.alpha = 1.0
        }
    }
    
    func disableButton(button: UIButton) {
        button.isEnabled = false
        UIView.animate(withDuration: 0.05) {
            button.alpha = 0.5
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= EditorTextViewConstants.charUpperBound
    }
    
    func textViewDidChange(_ textView: UITextView) {
        charCountLabel.text = String(EditorTextViewConstants.charUpperBound - textView.text.count)
    }
}
