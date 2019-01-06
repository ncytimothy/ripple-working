//
//  QuoteCell.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

class QuoteCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var quote: Quote? {
        didSet {
            if let category = quote?.category {
                categoryLabel.text = category.uppercased()
                categoryLabel.font = UIFont.boldSystemFont(ofSize: 15)
                categoryLabel.textColor = UIColor.signatureOrange
            }
            
            
            if let quoteString = quote?.quoteString {
                quoteTextView.text = quoteString
            }
            
            if let author = quote?.author {
                authorLabel.text = author
            }
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "INSPIRING"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.signatureOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let quoteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = "You're going to go through tough times - that's life. But I say, 'Nothing happens to you, it happens for you.' See the positive in negative events."
        textView.backgroundColor = .white
        textView.textColor = .black
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.text = "Joel Osteen"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        backgroundColor = .white
        
        layer.cornerRadius = 20
        
        addSubview(categoryLabel)
        addSubview(quoteTextView)
        addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            quoteTextView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            quoteTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            quoteTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            quoteTextView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.425),
            
            authorLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            authorLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            
            ])
    }
    
    static func setButtonFor(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.primaryOrange, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
