//
//  FlickerSearchViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 19/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class FlickerSearchViewController: UIViewController {

    @IBOutlet fileprivate weak var searchContainer: UIView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    private var searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInIt()
    }
}
private extension FlickerSearchViewController {
    func commonInIt(){
        searchSetup()
        collectionViewSetup()
    }
    func searchSetup(){
        searchController.searchResultsUpdater = self
        searchContainer.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }
    func collectionViewSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}

extension FlickerSearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickerPhotoCell", for: indexPath) as! FlickerPhotoCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHeight: CGFloat = (view.frame.width / 3)
        let totalWidth: CGFloat = (view.frame.width / 3)
        return CGSize(width: ceil(totalWidth - 8), height: ceil(totalHeight - 8))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
extension FlickerSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}
