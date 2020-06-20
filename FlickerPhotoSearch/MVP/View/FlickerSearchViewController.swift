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
    private var photos: [Photo] = []
    private var pageNum: Int = 1
    private var searchStr = ""
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = searchStr
    }
}
private extension FlickerSearchViewController {
    func commonInIt(){
        searchSetup()
        collectionViewSetup()
    }
    func searchSetup(){
        searchController.searchBar.delegate = self
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
        return self.photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickerPhotoCell", for: indexPath) as! FlickerPhotoCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoObject = photos[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        vc.imageTitle = photoObject.title
        vc.url = photoObject.imageUrl("z")
        searchController.isActive = false
        
        vc.thumbImage = (collectionView.cellForItem(at: indexPath) as? FlickerPhotoCell)?.imageView.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let url = photos[indexPath.row].imageUrl() else { return }
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMorePhotos()
        }
        NetworkManager.shared.getImage(from: url) { (imageData) in
            DispatchQueue.main.async {
                let cell = collectionView.cellForItem(at: indexPath) as? FlickerPhotoCell
                cell?.imageView.image = UIImage(data: imageData)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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

extension FlickerSearchViewController {
    
    func loadMorePhotos(){
        pageNum += 1
        NetworkManager.shared.getPhotos(for: self.searchStr, with: pageNum) { (photos, error) in
            if photos != nil {
                self.photos += photos!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension FlickerSearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchStr = searchBar.text else { return }
        photos.removeAll()
        collectionView.reloadData()
        searchController.isActive = false
        searchController.searchBar.text = searchStr
        self.searchStr = searchStr
        NetworkManager.shared.getPhotos(for: searchStr, with: pageNum) { (photos, error) in
            if photos != nil {
                self.photos = photos!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
