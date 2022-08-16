//
//  ContentModel.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 04.08.2022.
//

import Foundation

protocol ContentModelDelegate {
    
    func loadCollections(collections: [Collection])
}


class ContentModel {
    
    var collections = [Collection]()
    var delegate: ContentModelDelegate?
    
    
    // MARK: - Data Managment
    func save() {
        
        if let encoded = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    
    
    func loadSavedCollections() {
        
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            
            if let decoded = try? JSONDecoder().decode([Collection].self, from: data) {
                
                collections = decoded
                
                self.delegate?.loadCollections(collections: collections)
            }
        }
    }
    
    // MARK: - Collection Section
    func addCollection(title: String) {
        
        collections.append(Collection(id: UUID(), title: title))
        
        save()
        self.delegate?.loadCollections(collections: self.collections)
    }
    
    func removeCollection(collectionId: Int) {
        
        collections.remove(at: collectionId)
        
        save()
        self.delegate?.loadCollections(collections: self.collections)
    }
    
}
