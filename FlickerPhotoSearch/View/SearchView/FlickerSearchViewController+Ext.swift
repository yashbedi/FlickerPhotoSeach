//
//  FlickerSearchViewController+Ext.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 22/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

extension FlickerSearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.photos.count == 0) {
            self.collectionView.setEmptyMessage(Constants.kNoData)
        } else {
            self.collectionView.restore()
        }
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kFlickerPhotoCell,
                                                      for: indexPath) as! FlickerPhotoCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoObject = photos[indexPath.row]
        let imageDetailViewController = UIStoryboard.init(name: Constants.kMain, bundle: nil).instantiateViewController(withIdentifier: Constants.kImageDetailViewController) as! ImageDetailViewController
        imageDetailViewController.imageTitle = photoObject.title
        imageDetailViewController.url = photoObject.imageUrl(Constants.imageSizeL)
        searchController.isActive = false
        
        imageDetailViewController.thumbImage = (collectionView.cellForItem(at: indexPath) as? FlickerPhotoCell)?.imageView.image
        self.navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let url = photos[indexPath.row].imageUrl() else { return }
        
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex{
            isPagingEnabled = true
            pageMorePhotos()
            return
        }
        DownloadImageService.shared.getImage(from: url, indexPath: indexPath) { (data, index, key) in
            if data != nil {
                DispatchQueue.main.async {
                    let cell = collectionView.cellForItem(at: index!) as? FlickerPhotoCell
                    cell?.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isPagingEnabled { return }
        guard
            self.photos.count > indexPath.row,
            let uRL = self.photos[indexPath.row].imageUrl() else { return }
        DownloadImageService.shared.prolongDownloadForImages(with: uRL)
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.kFooterLoaderView,
                                                                         for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: -50, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if isPagingEnabled {
            footerView.frame.origin.y = 0
        }
        footerView.startAnimating()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        footerView.stopAnimating()
    }
}


extension FlickerSearchViewController {
    
    @objc func toggleDarkMode(){
        let mode = NaiveDarkAndLightMode.current()
        if mode == .Dark {
            NaiveDarkAndLightMode.applyMode(mode: .Light)
        }else{
            NaiveDarkAndLightMode.applyMode(mode: .Dark)
        }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.kSelectedMode),
                                        object: nil)
    }
    
    @objc func changeMode() {
        UIView.animate(withDuration: 0.9, animations: {
            if self.photos.count == 0 {
                self.collectionView.reloadData()
            }
            self.footerView.color = NaiveDarkAndLightMode.current().darkGrey
            self.searchController.searchBar.barStyle = NaiveDarkAndLightMode.current().barStyle
            self.view.backgroundColor = NaiveDarkAndLightMode.current().background
            self.searchController.searchBar.keyboardAppearance = NaiveDarkAndLightMode.current().keyBoardAppearance
            self.searchController.searchBar.tintColor = NaiveDarkAndLightMode.current().darkGrey
            self.searchContainer.backgroundColor = NaiveDarkAndLightMode.current().background
            self.navigationController?.navigationBar.barTintColor = NaiveDarkAndLightMode.current().fillColor
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.07868818194, green: 0.6650877595, blue: 0.992734015, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : NaiveDarkAndLightMode.current().darkGrey]
        }) { (done) in }
    }
}
