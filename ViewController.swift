//
//  ViewController.swift
//  CalendarScroll
//
//  Created by Daniel Lahoz on 29/6/16.
//  Copyright © 2016 Lahoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var scrollViewWidthContraint: NSLayoutConstraint!
  
    
  var data = [Date]()
    let calendarG = CalendarGenerator()
    
  var cellWidth = CGFloat()
    var canAddToBeginning : Bool = false
    var mustAddToBeginning : Bool = false
  
  override func viewDidLoad() {
    self.prepareCollectionView()
  }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.contentOffset = CGPoint(x: self.cellWidth * 12, y: 0)
        self.canAddToBeginning = true
    }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
//  override func
}

//MARK: - PREPARING SUBVIEWS
extension ViewController {
  
  func prepareCollectionView() {
    
    let current = calendarG.getCurrentMonth()
    var month = current.getPreviusYear()
    
    self.data.append(month as Date)
    
    for _ in 0...23 {
        month = month.getNextMonth()
        self.data.append(month as Date)
    }
    

    self.collectionView.reloadData()
    self.collectionView.contentOffset = CGPoint(x: self.cellWidth * 12, y: 0)
    
    
  }
  
}

//MARK: - COLLECTION VIEW DATA SOURCE PREFECTCHING
extension ViewController: UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //Precached stuff
    }
  
}

//MARK: - COLLECTION VIEW DATA SOURCE
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count

  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let cellDate = data[(indexPath as NSIndexPath).item]
        cell.monthLabel.text = cellDate.getMonthDescription()
        cell.month = cellDate
    
    //print(" index: \(indexPath.item) data:\(data.count - 3)")
    
        if (indexPath as NSIndexPath).item >= data.count - 3 {
            self.lastCellDataRelaoded()
        }
    
        if (indexPath as NSIndexPath).item <= 1{
            if canAddToBeginning{
                canAddToBeginning = false
                mustAddToBeginning = true
            }

        }
    
        return cell
    
  }
    
    func lastCellDataRelaoded() {

        self.collectionView.performBatchUpdates({
            
            let lastMonth = self.data[self.data.count - 1]
            let newLastMonth = lastMonth.getNextMonth()

            self.data.append(newLastMonth)

            self.collectionView.insertItems(at: [IndexPath(item: self.data.count - 1, section: 0)])

        }, completion: { completion in
            //self.prepareScrollView()
        
        })

    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView && self.mustAddToBeginning{
            self.mustAddToBeginning = false
            self.collectionView.isUserInteractionEnabled = false
            
            CATransaction.begin()
            CATransaction.setDisableActions(true) // <- This avoid the rare flicker effect
            
            self.collectionView.performBatchUpdates({
                
                for _ in 0...6{
                    
                    let firtsMonth = self.data[0]
                    let newFirstMonth = firtsMonth.getPreviusMonth()
                    
                    self.data.insert(newFirstMonth, at: 0)
                    
                    self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                }
                
                }, completion: { completion in
                    self.collectionView.contentOffset = CGPoint(x: self.cellWidth * 9, y: 0)
                    self.canAddToBeginning = true
                    self.collectionView.isUserInteractionEnabled = true
                    CATransaction.commit()
            })
            
        }
        
    }
    
}

//MARK: - CUSTOMIZING COLLECTION VIEW FLOW LAYOUT
extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    self.cellWidth = self.collectionView.frame.width // self.collectionView.frame.height - (layout.sectionInset.top + layout.sectionInset.top)
    //print("size: \(CGSize(width: self.cellWidth, height: self.collectionView.frame.height - layout.sectionInset.top * 2))")
    return CGSize(width: self.cellWidth, height: self.collectionView.frame.height - layout.sectionInset.top * 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}


