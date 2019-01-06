//
//  ActivityCell.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gratitude: Gratitude? {
        didSet {
            if let gratitudeString = gratitude?.gratitudeString {
                gratitudeTextView.text = gratitudeString
            }
            
            if let feeling = gratitude?.feeling, let imageName = feeling.imageName {
                feelingImageView.image = UIImage(named: imageName)
            }
            
            if let date = gratitude?.creationDate {
                let dateString = dateFormatter.string(from: date)
                dateLabel.text = dateString
            }
            
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Gratitude"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    let feelingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "happy")
        imageView.contentMode = .scaleAspectFit
        print("imageView.intrinsicContentSize: \(imageView.intrinsicContentSize)")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        //        imageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        
        return imageView
    }()
    
    let gratitudeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Hi Emma, thank you for always being here for me and listening to what’s on my mind. \n\nI had a lot fun with you in our trip and I value your genuine attitude towards life. <3"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        //        textView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        return textView
    }()
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Tuesday, April 3, 2018"
        label.textColor = .signatureOrange
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        let stackView = UIStackView(arrangedSubviews: [feelingImageView, gratitudeTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillProportionally
        //        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        
        addSubview(titleLabel)
        addSubview(dividerLineView)
        addSubview(dateLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            dividerLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dividerLineView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            dividerLineView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dividerLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            dateLabel.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            //            feelingImageView.heightAnchor.constraint(equalToConstant: 20),
            //            feelingImageView.widthAnchor.constraint(equalToConstant: 20),
            
            
            gratitudeTextView.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            //            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.68)
            
            
            
            ])
    }
    
}
