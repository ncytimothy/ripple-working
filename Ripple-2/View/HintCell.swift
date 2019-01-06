//
//  HintCell.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

class HintCell: UICollectionViewCell {
    
    // Since all variables need to be intialized in the class
    // we may set this "page" variable to an optional and then
    // set it to nil with the open braces { ... }
    var page: Page? {
        // Run the "didSet" block in didSet when the page property is set
        didSet {
            //            print(page?.imageName)
            guard let page = page else { return }
            //            guard let imageName = page?.imageName else { return }
            //            guard let headerText = page?.headerText else { return }
            
            
            imageView.image = UIImage(named: page.imageName)
            
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            
            let attributedText = NSMutableAttributedString(string: page.headerText, attributes: [
                NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.bodyText)", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.foregroundColor: UIColor.white
                ]))
            
            
            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .center
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "start-small"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .primaryOrange
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let attributedText = NSMutableAttributedString(string: "Start Small.", attributes: [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: "\n\nAppreciate the smallest deeds. A simple coffee chat can be something to be thankful for.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        textView.attributedText = attributedText
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        // Call the setup function when the cell is being initialized
        setupLayout()
    }
    
    // Have to do this everytime your override
    // Learn more about this
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .primaryOrange
        let topImageContainterView = UIView()
        
        addSubview(topImageContainterView)
        addSubview(descriptionTextView)
        
        topImageContainterView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainterView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // Certain languauges, such as Arabic would follow right to left,
        // using leading and trailing would allow for constraints
        // to follow this rule as such
        topImageContainterView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainterView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // Set up the height anchor for the container view such that the containter takes 0.5x of the superview
        // when the orientation changes, the heightAnchor will adjust since the superview's heightAnchor has changed but the proportion stays the same
        // the container area will shrink, and from the code below for startSmallImageView, the startSmallImageView will shrink also
        topImageContainterView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        topImageContainterView.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: topImageContainterView.centerXAnchor).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: topImageContainterView.centerYAnchor).isActive = true
        
        // Set up the startSmallImageView such that it takes up 0.5x of the container view
        imageView.heightAnchor.constraint(equalTo: topImageContainterView.heightAnchor, multiplier: 0.5).isActive = true
        
        
        descriptionTextView.topAnchor.constraint(equalTo: topImageContainterView.bottomAnchor).isActive = true
        
        //         Need pushing to the right by 24 pixels
        //         Left side padding
        descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        
        //         Need pushing to the left by 24 pixels
        //         Right side padding
        descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    
}
