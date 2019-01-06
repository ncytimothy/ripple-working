//
//  QuoteViewController+CollectionExtension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension QuoteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        quoteCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        quoteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        quoteCollectionView.backgroundColor = .primaryOrange
        quoteCollectionView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: quoteCollectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: quoteCollectionView.centerYAnchor)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? CollectionViewConstants.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: quoteCellId, for: indexPath) as! QuoteCell
        
        //GUARD TO BE USED AND NEEDED
        // This is guard away the unneccesary redownloading of quotes when the
        // persistent store already exists
        guard !(self.fetchedResultsController.fetchedObjects?.isEmpty)! else { return cell }
        cell.quote = self.fetchedResultsController.object(at: indexPath)
        cell.alpha = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let longText = fetchedResultsController.object(at: indexPath).quoteString
        let rect = NSString(string: longText ?? "Long Quote").boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
        return CGSize(width: view.frame.width - 20, height: rect.height + 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let quoteCell = collectionView.cellForItem(at: indexPath) as! QuoteCell
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse], animations: {
            quoteCell.alpha = 0.5
            quoteCell.alpha = 1
        }, completion: nil)
        
        
        handleTag(collectionView, indexPath)
    }
    
}

