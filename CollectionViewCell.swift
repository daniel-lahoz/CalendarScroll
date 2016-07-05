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
    
    var previusdays = [Date]()
    var monthdays = [Date]()
    
    var month = Date(){
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


//MARK: - COLLECTION VIEW DATA SOURCE PREFECTCHING
extension CollectionViewCell: UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //Precached stuff
    }
    
}

//MARK: - COLLECTION VIEW DATA SOURCE
extension CollectionViewCell : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let smallCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        
        if (indexPath as NSIndexPath).item < previusdays.count {
            smallCell.numberLabel.text = previusdays[(indexPath as NSIndexPath).item].getTextDay()
            smallCell.alpha = 0.4
        }else{
            smallCell.numberLabel.text = monthdays[(indexPath as NSIndexPath).item - previusdays.count].getTextDay()
            smallCell.alpha = 1.0
        }
        
        return smallCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthNumber
    }
    
}

//MARK: - COLLECTION VIEW FLOW
extension CollectionViewCell : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var rows = CGFloat(trunc( Float(monthNumber) / 7))
        if monthNumber % 7 != 0 {
            rows = rows + 1
        }
        
        //print("\(monthLabel.text) \(monthNumber) \(rows)")
        
        return CGSize(width: collectionView.frame.size.width/7 - 1, height:collectionView.frame.size.height/rows - 1)
    }
        
}

//MARK: - COLLECTION VIEW DELEGATE
extension CollectionViewCell : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Do stuff...
    }
    
}
