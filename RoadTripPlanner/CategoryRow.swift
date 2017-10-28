//
//  CategoryRow.swift
//  RoadTripPlanner
//
//  Created by Deepthy on 10/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//
import UIKit
import YelpAPI

protocol CategoryRowDelegate : class{
    func didClick(cell:BusinessCollectionCell)
}
class CategoryRow : UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var businesses: [YLPBusiness]!
    weak var delegate : CategoryRowDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

extension CategoryRow : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BCell", for: indexPath) as! BusinessCollectionCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked collection cell indexpath \(indexPath.row)")
        
        let cell = collectionView.cellForItem(at: indexPath) as! BusinessCollectionCell
        print("clicked collection cell indexpath \(cell.businessName)")

  //      cell.delegate = self

        let mapViewController = MapViewController()
        //mapViewController.openBottomSheetview(cell: cell)
        let bottomSheetVC = BusinessBottomSheetViewController()
        //bottomSheetVC.transitioningDelegate = self
    //    self.collectionView.p.present(bottomSheetVC, animated: true, completion: nil)

    }

}

extension CategoryRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}


