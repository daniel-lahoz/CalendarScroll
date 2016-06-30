//
//  Cellule.swift
//  CalendarScroll
//
//  Created by Daniel Lahoz on 29/6/16.
//  Copyright © 2016 Lahoz. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    var monthNumber = 0
    
    @IBOutlet weak var cellCollectioView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var previusdays = [NSDate]()
    var monthdays = [NSDate]()
    
    var month = NSDate(){
        didSet {
            
            (previusdays, monthdays) = month.getDaysOfTheMonth()
            
            monthNumber = previusdays.count + monthdays.count
            self.cellCollectioView.reloadData()
        }
    }
    
    override func prepareForReuse() {
        monthLabel.text = ""
        monthNumber = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
    
extension CollectionViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
        
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let smallCell = collectionView.dequeueReusableCellWithReuseIdentifier("dayCell", forIndexPath: indexPath) as! DayCollectionViewCell
        
        if indexPath.item < previusdays.count {
            smallCell.numberLabel.text = previusdays[indexPath.item].getTextDay()
            smallCell.alpha = 0.4
        }else{
            smallCell.numberLabel.text = monthdays[indexPath.item - previusdays.count].getTextDay()
            smallCell.alpha = 1.0
        }
        
        return smallCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthNumber
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var rows = CGFloat(trunc( Float(monthNumber) / 7))
        if monthNumber % 7 != 0 {
            rows = rows + 1
        }
        
        print("\(monthLabel.text) \(monthNumber) \(rows)")
        
        return CGSize(width: collectionView.frame.size.width/7 - 1, height:collectionView.frame.size.height/rows - 1)
    }
        
}
