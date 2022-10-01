//
//  ContentModel.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 04.08.2022.
//

import Foundation
import UIKit


class ContentModel {
    
    static var collections = [Collection]()
    
    // MARK: - Data Managment
    func save() {
        
        if let encoded = try? JSONEncoder().encode(ContentModel.collections) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    
    
    func loadSavedCollections() {
        
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            
            if let decoded = try? JSONDecoder().decode([Collection].self, from: data) {
                
                ContentModel.collections = decoded
            }
        }
    }
    
    func createDeleteAlert(alertTitle: String, alertMessage: String, index: Int) -> UIAlertController {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            self.removeCollection(collectionId: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    // MARK: - Collection Section
    func addCollection(title: String) {
        
        ContentModel.collections.append(Collection(id: UUID(), title: title))
        save()
    }
    
    func removeCollection(collectionId: Int) {
        
        ContentModel.collections.remove(at: collectionId)
        save()
    }
    
    func removeAllCollections() {
        
        ContentModel.collections.removeAll()
        save()
    }
    
    
    // MARK: - Card Section
    
    func addCard(collectionId: Int, front: String, back: String) {
        
        ContentModel.collections[collectionId].cards.append(Card(id: UUID(), front: front, back: back))
        save()
    }
    
    
    func removeAllCards(collectionId: Int) {
    
        ContentModel.collections[collectionId].cards.removeAll()
        save()
    }
    
}
