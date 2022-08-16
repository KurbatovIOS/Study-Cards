//
//  CollectionsListVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 16.08.2022.
//

import UIKit

class CollectionsListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = ContentModel()
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        model.delegate = self
        model.loadSavedCollections()
    }
    
    
    @IBAction func addCollectionButton(_ sender: Any) {
        
        // TODO: Correct message
        let alert = UIAlertController(title: "", message: "Enter collection name", preferredStyle: .alert)
        
        // Add text field
        alert.addTextField { textField in
            textField.placeholder = ""
            textField.keyboardType = .default
        }
        
        // Set buttons for alert
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            let collectionTitle = alert.textFields![0].text ?? ""
            
            self.model.addCollection(title: collectionTitle == "" ? "Collection \(self.collections.count + 1)" : collectionTitle)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: false)
    }
}

extension CollectionsListVC: ContentModelDelegate {
    
    func loadCollections(collections: [Collection]) {
        self.collections = collections
        self.collectionView.reloadData()
    }
}


// MARK: - CollectionView

extension CollectionsListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    
    // Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // set cell size
        let size = (collectionView.frame.width / 2) * 0.9
        
        // TODO: Configure size for Ipads
        
        return CGSize(width: size, height: size)
    }
    
    // Spacing between lines of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    // Cell configuration
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        
        cell.setUpCell(collectionToDisplay: collections[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToCards", sender: self)
        
    }
}
