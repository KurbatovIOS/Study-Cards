//
//  ContentModel.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 04.08.2022.
//

import Foundation

//protocol ContentModelDelegate {
//
//    func loadCollections(collections: [Collection])
//}


//var collections = [Collection]()


class ContentModel {
    
    //var collections = [Collection]()
    //var delegate: ContentModelDelegate?
    
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
                
                //self.delegate?.loadCollections(collections: collections)
            }
        }
    }
    
    // MARK: - Collection Section
    func addCollection(title: String) {
        
        ContentModel.collections.append(Collection(id: UUID(), title: title))
        
        save()
        //self.delegate?.loadCollections(collections: self.collections)
    }
    
    func removeCollection(collectionId: Int) {
        
        ContentModel.collections.remove(at: collectionId)
        
        save()
        //self.delegate?.loadCollections(collections: self.collections)
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
    
}
