//
//  FlickerSearchViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 19/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class FlickerSearchViewController: BaseViewController {

    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [Photo] = []
    var pageNum: Int = 1
    var searchStr = ""
    var isPagingEnabled: Bool = false
    
    let footerView : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium
        loader.color = NaiveDarkAndLightMode.current().darkGrey
        loader.hidesWhenStopped = true
        return loader
    }()
    
    var searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = Constants.kSearchPlaceholder
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInIt()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = searchStr
        changeMode()
    }
}

private extension FlickerSearchViewController {
    func commonInIt(){
        searchSetup()
        collectionViewSetup()
        extraSetup()
    }
    func searchSetup(){
        searchController.searchBar.delegate = self
        searchContainer.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }
    
    func collectionViewSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FooterLoaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: Constants.kFooterLoaderView)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width,
                                                                                                           height: 50)
    }
    
    func extraSetup(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeMode),
                                               name: NSNotification.Name(Constants.kSelectedMode),
                                               object: nil)
        
        let darkMode = UIBarButtonItem.init( title: "🚀",
                                             style: .plain,
                                             target: self,
                                             action: #selector(toggleDarkMode))
        
        navigationItem.rightBarButtonItems = [darkMode]
    }
}


extension FlickerSearchViewController {
    
    func pageMorePhotos(){
        if searchStr == "" { return }
        pageNum += 1
        NetworkManager.shared.getPhotosData(for: self.searchStr,
                                            with: pageNum) { (photos, error) in
            if error == Constants.kNoInternet{
                super.showAlert(with: Constants.kNoInternet,
                                and: "")
                self.isPagingEnabled = false
                return
            }
            if photos != nil {
                self.photos += photos!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPagingEnabled = false
            }
        }
    }
}

extension FlickerSearchViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStr = ""
        isPagingEnabled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStr = searchText
        isPagingEnabled = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let searchStr = searchBar.text,
            searchStr.count > 0
            else { return }
        
        photos.removeAll()
        collectionView.reloadData()
        searchController.isActive = false
        searchController.searchBar.text = searchStr
        self.searchStr = searchStr
        super.showLoading()
        
        NetworkManager.shared.getPhotosData(for: searchStr,
                                            with: pageNum) { (photos, error) in
            super.hideLoading()
            if error == Constants.kNoInternet{
                super.showAlert(with: Constants.kNoInternet,
                                and: "")
                self.isPagingEnabled = false
                return
            }
            if photos != nil {
                self.photos = photos!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
