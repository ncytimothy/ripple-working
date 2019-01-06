//
//  HintViewController.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

class HintViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let hintCell = "hintCell"
    
    let pages: [Page] = [
        Page(imageName: "start-small", headerText: "Start Small.", bodyText: "Appreciate the smallest deeds. A simple coffee chat can be something to be thankful for."),
        Page(imageName: "specific", headerText: "Be specific.", bodyText: "Let the other person know exactly what you are thanking he/she for."),
        Page(imageName: "detail", headerText: "More details the better.", bodyText: "Write in as much detail as possible, including what the other person did and why he/she has made your life better."),
        Page(imageName: "feelings", headerText: "Talk about your feelings.", bodyText: "Tell the other person how you felt after he/she gave help to you and how important he/she is to you."),
        Page(imageName: "grammar", headerText: "Don't worry about perfect grammar or spelling", bodyText: "Casual spelling and grammar is totally alright! It's more important to send a heartfelt and genuine message."),
        Page(imageName: "time", headerText: "Take your time.", bodyText: "Take 1 - 3 minutes to write your heartfelt message."),
        
        ]
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // lazy var: allows to access members of your class
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the lazy modifier before its declaration.
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.white
        pc.pageIndicatorTintColor = UIColor.darkenOrange
        return pc
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBottomControls()
        setupDoneButton()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // velocity: how fast you are scrolling
        // targetContentOffset.pointee (CGPoint)
        // x: where the scrollview is going to stop the drag
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        print(x, view.frame.width, x / view.frame.width)
    }
    
    fileprivate func setupBottomControls() {
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomControlsStackView.distribution = .fillEqually
        
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
    }
    
    fileprivate func setupDoneButton() {
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
            ])
    }
    
    
    
    @objc private func handlePrev() {
        print("Trying to go to prev...")
        // Collection Views have IndexPath(item:section:)
        // Take the max of the current page - 1  and the pages count (by index) so that the next button will not go
        // out of bounds
        let prevIndex = max(0, pageControl.currentPage - 1)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleNext() {
        print("Trying to advance to next...")
        // Collection Views have IndexPath(item:section:)
        // Take the min of the current page + 1 and the pages count (by index) so that the next button will not go
        // out of bounds
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
