//
//  FlickerSearchViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 19/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class FlickerSearchViewController: UIViewController {

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
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
        setUI()
        setHierarchy()
        setConstraints()
    }
    func setUI(){
        setUpNavBar()
        setUpSearchBar()
    }
    func setHierarchy(){
        view.addSubview(collectionView)
    }
    func setConstraints(){
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}
private extension FlickerSearchViewController {
    func setUpNavBar(){
        view.backgroundColor = .yellow
        title = "Image Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setUpSearchBar(){
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension FlickerSearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
extension FlickerSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}
