//
//  CollectionsListVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 16.08.2022.
//

import UIKit

class CollectionsListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var messageLabel: UILabel!
        
    var model = ContentModel()
    //var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        model.loadSavedCollections()
        
        //TODO: Correct label
        messageLabel.text = "You have no collections yet"
        
        //model.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
        
        if ContentModel.collections.count > 0 {
            
            messageLabel.alpha = 0
        }
        else {
            messageLabel.alpha = 1
        }
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cardsVC = segue.destination as! CardsVC
        
        let indexPath = collectionView.indexPathsForSelectedItems?[0]
        
        cardsVC.collectionId = indexPath?.row
    }
    
    
    @IBAction func longPressToRemoveCollection(_ sender: Any) {
        
        
        //TODO: Pick between edit and delete collection
        
        let alert = UIAlertController(title: "Delete", message: "edf", preferredStyle: .alert)
  
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            //
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//        let button = UIButton()
//        
//        button.menu = UIMenu()
        
        present(alert, animated: true)
    }
    
    
    
    @IBAction func addCollectionButton(_ sender: Any) {
        
        // TODO: Correct message
        let alert = UIAlertController(title: "Create collection", message: "Enter collection title", preferredStyle: .alert)
        
        // Add text field
        alert.addTextField { textField in
            textField.placeholder = ""
            textField.keyboardType = .default
        }
        
        // Set buttons for alert
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            let collectionTitle = alert.textFields![0].text ?? ""
            
            self.model.addCollection(title: collectionTitle == "" ? "Collection \(ContentModel.collections.count + 1)" : collectionTitle)
            
            if ContentModel.collections.count > 0 {
                
                self.messageLabel.alpha = 0
            }
            
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @IBAction func removeAllCollections(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete all collections?", message: "Are you sure you want to delete all collections?", preferredStyle: .alert)
        
        // Remove action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            self.model.removeAllCollections()
            self.collectionView.reloadData()
            self.messageLabel.alpha = 1
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

//extension CollectionsListVC: ContentModelDelegate {
//
//    func loadCollections(collections: [Collection]) {
//        self.collections = collections
//        self.collectionView.reloadData()
//    }
//}


// MARK: - CollectionView

extension CollectionsListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ContentModel.collections.count
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
        
        cell.setUpCell(collectionToDisplay: ContentModel.collections[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToCards", sender: self)
    }
}
