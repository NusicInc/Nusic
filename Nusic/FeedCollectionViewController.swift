//
//  FeedCollectionViewController.swift
//  Nusic
//
//  Created by Alex Rapier on 20/04/2017.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class FeedCollectionViewController: UICollectionViewController, FeedCellDelegate {
    
    var artistID:Int?

    var request: String! {
        didSet {
            
            //progress HUD
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"

            requestArtistID(input: request) { (artistName, artistId, artistPhoto) in
                
                print("name \(artistName), id \(artistId), photo \(artistPhoto)")
                
                
                self.artistID = artistId
                
                requestArtistNews(input: artistId) {

                    
                    DispatchQueue.main.async {
                        
                        //dismiss HUD and reload
                        MBProgressHUD.hide(for: self.view, animated: true)
//                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                        self.collectionView?.reloadData()
                        
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NUSIC"
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        layout.itemSize = itemSize
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return articlesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        
        let article = articlesArray[indexPath.row] 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedCollectionViewCell
        
        cell.article = article
        cell.delegate = self
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //pass URL string to destination view controller (WebTableViewController) and assign to passedURL        
        if segue.identifier == "WebViewController" {
            if let webCollectionViewController = segue.destination as? WebViewController {
                if let button = sender as? UIButton {
                    let cell = button.superview?.superview as! FeedCollectionViewCell
                    webCollectionViewController.passedURL = cell.article.articleURL
                }
                
                if let cell = sender as? FeedCollectionViewCell {
                    webCollectionViewController.passedURL = cell.article.articleURL
                }
                
                if segue.identifier == "BioViewController" {
                    if let bioViewController = segue.destination as? BioViewController {
                        if let button = sender as? UIButton {
                            let cell = button.superview?.superview as! FeedCollectionViewCell
                            requestArtistBio(input: artistId, complete: <#T##((String) -> Void)##((String) -> Void)##(String) -> Void#>)
                            bioViewController.passedWikiURL = bioURL
                        }
                    }
                }

                
            }
            
        }

    }
    
    // MARK: - FeedCellDelegate
    
    func showDetails(cell: FeedCollectionViewCell) {
        performSegue(withIdentifier: "WebViewController", sender: cell)
    }
}
