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
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var scrollViewWidthContraint: NSLayoutConstraint!
  
  let verticalInset = CGFloat(10)
  let spaceBetweenCells = CGFloat(10)
  var horizontalInset = CGFloat()
    
  var data = [Date]()
    let calendarG = CalendarGenerator()
    
  var cellWidth = CGFloat()
    var canadd : Bool = false
  
  override func viewDidLoad() {
    self.prepareCollectionView()
    self.containerView.addGestureRecognizer(self.scrollView.panGestureRecognizer)
  }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentOffset = CGPoint(x: (self.cellWidth + self.spaceBetweenCells) * 12, y: 0)
        //self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 6, inSection: 0), animated: false, scrollPosition: .None)
        self.canadd = true
    }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.prepareScrollView()
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
    
    
  }
  
  func prepareScrollView() {
    self.scrollViewWidthContraint.constant = self.cellWidth + spaceBetweenCells
    self.scrollView.contentSize.width = (self.cellWidth + self.spaceBetweenCells) * CGFloat(self.data.count + 1)
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
            self.perform(#selector(self.lastCellDataRelaoded))
        }
    
        if (indexPath as NSIndexPath).item <= 1{
            if canadd{
                canadd = false
                print("add new")
                 self.perform(#selector(self.firstCellDataRelaoded))
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
                self.prepareScrollView()
        
        })

    }
    
    func firstCellDataRelaoded() {
        
        self.collectionView.performBatchUpdates({
            
            for _ in 0...6{
                
                let firtsMonth = self.data[0]
                let newFirstMonth = firtsMonth.getPreviusMonth()
                
                self.data.insert(newFirstMonth, at: 0)
                
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
            
            }, completion: { completion in
                //self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 5, inSection: 0), animated: false, scrollPosition: .None)
                self.perform(#selector(self.movescroll), with: nil, afterDelay: 0.0)
                self.canadd = true
                
        })

        
    }
    
    func movescroll(){
        self.scrollView.contentOffset = CGPoint(x: (self.cellWidth + self.spaceBetweenCells) * 9, y: 0)
    }
    
}

//MARK: - CUSTOMIZING COLLECTION VIEW FLOW LAYOUT
extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return self.spaceBetweenCells
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    self.cellWidth = self.collectionView.frame.width // self.collectionView.frame.height - (layout.sectionInset.top + layout.sectionInset.top)
    self.horizontalInset = (self.collectionView.frame.width - self.cellWidth) / 2
    return CGSize(width: self.cellWidth, height: self.collectionView.frame.height - layout.sectionInset.top * 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    return UIEdgeInsets(top: layout.sectionInset.top, left: self.horizontalInset, bottom: layout.sectionInset.top, right: self.horizontalInset)
  }
}

//MARK: - CUSTOMIZING SCROLL VIEW
extension ViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.collectionView.contentOffset.x = scrollView.contentOffset.x
  }
  /*
  func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    if let selected = self.collectionView.indexPathForItemAtPoint(CGPoint(x: targetContentOffset.memory.x + self.collectionView.frame.width / 2, y: self.collectionView.frame.height / 2)) {
        self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: selected.item, inSection: 0), animated: false, scrollPosition: .None)
    }
    
  }
   */ 
}


