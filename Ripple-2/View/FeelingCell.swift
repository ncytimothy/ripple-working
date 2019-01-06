//
//  FeelingCell.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

class FeelingCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var feeling: Feeling? {
        didSet {
            
            if let feelingImageName = feeling?.imageName {
                feelingImageView.image = UIImage(named: feelingImageName)
            }
            
            if let feelingText = feeling?.feelingString {
                titleLabel.text = feelingText
            }
            
        }
    }
    
    let feelingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "happy")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Happy"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.overlayOrange
        view.alpha = 0.0
        view.clipsToBounds = false
        view.layer.cornerRadius = 14
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        addSubview(colorOverlay)
        addSubview(feelingImageView)
        addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            feelingImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            feelingImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -12),
            feelingImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            feelingImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: feelingImageView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            colorOverlay.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            colorOverlay.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            colorOverlay.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0),
            colorOverlay.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0)
            
            ])
        
    }
}
