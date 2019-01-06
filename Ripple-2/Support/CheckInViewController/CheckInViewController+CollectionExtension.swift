//
//  CheckInViewController+CollectionExtension.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension CheckInViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 3.0
        
        let constraintMultiplier: CGFloat = 2
        let numOfCells: CGFloat = 2
        let numOfSpaces: CGFloat = numOfCells - 1
        
        
        let dimension = (view.frame.width - (numOfSpaces * space) - (constraintMultiplier * leadingConstraintForFeelingsCollection)) / numOfCells
        
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        feelingsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        feelingsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feelingsCollectionView.backgroundColor = UIColor.primaryOrange
        feelingsCollectionView.allowsSelection = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("fetchedResultsController.sections?[section].numberOfObjects: \(fetchedResultsController.sections?[section].numberOfObjects)")
        return fetchedResultsController.sections?[section].numberOfObjects ?? CollectionViewConstants.cellsCount
        //        return feelingsLive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feelingCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeelingCell
        feelingCell.feeling = self.fetchedResultsController.object(at: indexPath)
        
        return feelingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeelingCell
        
        guard let feelingText = cell.feeling?.feelingString else  { return }
        updateSelectUI(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeelingCell
        updateSelectUI(cell: cell)
    }
}

