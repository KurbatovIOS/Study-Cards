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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:)))
        
        collectionView.addGestureRecognizer(longPressGesture)
        
        model.loadSavedCollections()
        
        messageLabel.text = "You don't have collections yet"
        
        messageLabel.alpha = ContentModel.collections.count > 0 ? 0 : 1
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cardsVC = segue.destination as! CardsVC
        
        let indexPath = collectionView.indexPathsForSelectedItems?[0]
        
        cardsVC.collectionId = indexPath?.row
    }
    
    @objc func longPressAction(_ gesture: UIGestureRecognizer) {
        
        let point = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: point) {
                        
            // Main alert
            let actionSheet = self.model.createAlert(title: nil, message: nil, style: .actionSheet)
            
            // Delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                        
                // Delete collection alert
                let deleteAlert = self.model.createAlert(title: "Delete \(ContentModel.collections[indexPath.row].title)?", message: "Are you sure you want to delete \(ContentModel.collections[indexPath.row].title)?", style: .alert)
        
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

                    self.model.removeCollection(collectionId: indexPath.row)
                    self.collectionView.reloadData()

                    if ContentModel.collections.count < 1 {

                        self.messageLabel.alpha = 1
                    }
                }
                
                deleteAlert.addAction(deleteAction)

                self.present(deleteAlert, animated: true)
            }
                        
            let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
                
                let removeAlert = self.model.createAlert(title: "Rename \(ContentModel.collections[indexPath.row].title)", message: nil, style: .alert)
                                
                removeAlert.addTextField { textField in
                    
                    textField.text = ContentModel.collections[indexPath.row].title
                    textField.autocapitalizationType = .sentences
                }
                
                let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                    
                    guard let newTitle = removeAlert.textFields?[0].text else {
                        return
                    }
                    
                    if ContentModel.collections.contains(where: { collection in
                        collection.title.lowercased() == newTitle.lowercased()
                    }) {
                        
                        //TODO: Edit message
                        let warningAlert = self.model.createAlert(title: "This collection already exists", message: nil, style: .alert, isWarning: true)
                        
                        self.present(warningAlert, animated: true)
                    }
                    else {
                        if newTitle.trimmingCharacters(in: .whitespaces) != "" {
                            
                            ContentModel.collections[indexPath.row].title = newTitle
                            
                            self.model.save()
                            self.collectionView.reloadData()
                        }
                    }
                }
                removeAlert.addAction(doneAction)
                
                self.present(removeAlert, animated: true)
            }
            
            actionSheet.addAction(renameAction)
            actionSheet.addAction(deleteAction)
    
            present(actionSheet, animated: true)
        }
    }
    
    // MARK: - TopBar buttons
    
    @IBAction func addCollectionButton(_ sender: Any) {
        
        let alert = self.model.createAlert(title: "Create collection", message: "Enter collection name", style: .alert)
        
        // Add text field
        alert.addTextField { textField in
            textField.placeholder = ""
            textField.autocapitalizationType = .sentences
        }
        
        // Set alert buttons 
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            let collectionTitle = alert.textFields![0].text ?? ""
            
            if ContentModel.collections.contains(where: { collection in
                collection.title.lowercased() == collectionTitle.lowercased()
            }) {
                
                let warningAlert = self.model.createAlert(title: "This collection already exists", message: nil, style: .alert, isWarning: true)
                
                self.present(warningAlert, animated: true)
            }
            else {
                self.model.addCollection(title: collectionTitle.trimmingCharacters(in: .whitespaces) == "" ? "Collection \(ContentModel.collections.count + 1)" : collectionTitle)
                
                if ContentModel.collections.count > 0 {
                    
                    self.messageLabel.alpha = 0
                }
                
                self.collectionView.reloadData()
            }
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func removeAllCollections(_ sender: Any) {
        
        if !ContentModel.collections.isEmpty{
            
            let alert = self.model.createAlert(title: "Delete all collections?", message: "Are you sure you want to delete all collections?", style: .alert)
                        
            // Remove action
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                self.model.removeAllCollections()
                self.collectionView.reloadData()
                self.messageLabel.alpha = 1
            }))
            
            present(alert, animated: true)
        }
    }
}


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
