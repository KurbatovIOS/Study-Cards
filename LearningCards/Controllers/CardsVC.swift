//
//  CardsVC.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 16.08.2022.
//

import UIKit

class CardsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    let searchController = UISearchController()
    
    var model = ContentModel()
    
    var collectionId: Int?
    
    var filteredCards: [Card]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = traitCollection.userInterfaceStyle == .light ? .systemGray6 : .black
        
        navigationItem.title = ContentModel.collections[collectionId!].title
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        filteredCards = ContentModel.collections[collectionId!].cards
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ContentModel.collections[collectionId!].cards.count > 0 {
            
            messageLabel.alpha = 0
        }
        else {
            messageLabel.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Bar buttons
    @IBAction func removeButtonAction(_ sender: Any) {
        
        if self.collectionId != nil  && !ContentModel.collections[self.collectionId!].cards.isEmpty {
            
            let alert = self.model.createAlert(title: "Delete all cards?", message: "Are you sure you want to delete all cards?", style: .alert)
                        
            // Remove action
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                if self.collectionId != nil {
                    self.model.removeAllCards(collectionId: self.collectionId!)
                    self.filteredCards.removeAll()
                    self.messageLabel.alpha = 1
                    self.tableView.reloadData()
                }
            }))
            
            present(alert, animated: true)
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        guard collectionId != nil else {
            return
        }

        let alert = self.model.createAlert(title: "Creat a new card", message: nil, style: .alert)

        alert.addTextField { textField in

            textField.placeholder = "front"
            textField.autocapitalizationType = .sentences
        }

        alert.addTextField { textField in

            textField.placeholder = "back"
            textField.autocapitalizationType = .sentences
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in

            // Get front and back titles
            let front = alert.textFields?[0].text
            let back = alert.textFields?[1].text

            guard front != nil && back != nil else {
                return
            }

            // If a cards with the same front and back already exists or if front or back is blank do nothing
            if ContentModel.collections[self.collectionId!].cards.contains(where: { card in
                card.front.lowercased() == front?.lowercased() && card.back.lowercased() == back?.lowercased()
            }) || front?.trimmingCharacters(in: .whitespaces) == "" || back?.trimmingCharacters(in: .whitespaces) == "" {

                let isBlank = front?.trimmingCharacters(in: .whitespaces) == "" || back?.trimmingCharacters(in: .whitespaces) == ""

                let warningAlert = self.model.createAlert(title: isBlank ? "Both fields must be filled in" : "This card is already in \(ContentModel.collections[self.collectionId!].title)", message: nil, style: .alert, isWarning: true)

                self.present(warningAlert, animated: true)
            }
            else {
                // else add a new card with given fron and back to the collection
                self.model.addCard(collectionId: self.collectionId!, front: front!, back: back!)
                self.filteredCards = ContentModel.collections[self.collectionId!].cards

                // Hide message if there is a card
                if ContentModel.collections[self.collectionId!].cards.count > 0 {
                    self.messageLabel.alpha = 0
                }

                self.tableView.reloadData()
            }
        }))

        present(alert, animated: true)
    }
}

//MARK: - SearchBar
extension CardsVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredCards = []

        if searchText == "" {
            filteredCards = ContentModel.collections[collectionId!].cards
        }
        else {
            for card in ContentModel.collections[collectionId!].cards {

                if card.front.lowercased().contains(searchText.lowercased()) {

                    filteredCards.append(card)
                }
            }
        }

        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        filteredCards = ContentModel.collections[collectionId!].cards
        self.tableView.reloadData()
    }
}

// MARK: - TableView
extension CardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        //cell.cardIndex = indexPath.row
        cell.card = filteredCards[indexPath.row]
        cell.collectionId = self.collectionId
       
        let card = filteredCards[indexPath.row]
        
        cell.setUpFrontLable(frontLabel: card.front)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "") { (action, view, success:(Bool) -> Void) in
            
            let selectedRowIndex = indexPath.row
            
            // TODO: move edit function into contentModel (problem: cant reload tableview data from model function)
            let cardId = self.model.getCardIndex(collectionId: self.collectionId!, front: self.filteredCards[selectedRowIndex].front, back: self.filteredCards[selectedRowIndex].back)
            
            if self.collectionId != nil && cardId != nil {

                let alert = self.model.createAlert(title: "Edit card", message: nil, style: .alert)
                
                alert.addTextField { textField in
                    
                    textField.text = ContentModel.collections[self.collectionId!].cards[cardId!].front
                    textField.autocapitalizationType = .sentences
                }
                
                alert.addTextField { textField in
                    
                    textField.text = ContentModel.collections[self.collectionId!].cards[cardId!].back
                    textField.autocapitalizationType = .sentences
                }
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    
                    let front = alert.textFields?[0].text
                    let back = alert.textFields?[1].text
                    
                    guard front != nil && back != nil else {
                        return
                    }
                    
                    // If a cards with the same front and back already exists or if front or back is blank do nothing
                    if ContentModel.collections[self.collectionId!].cards.contains(where: { card in
                        card.front.lowercased() == front?.lowercased() && card.back.lowercased() == back?.lowercased()
                    }) || front?.trimmingCharacters(in: .whitespaces) == "" || back?.trimmingCharacters(in: .whitespaces) == "" {
                        
                        let isBlank = front?.trimmingCharacters(in: .whitespaces) == "" || back?.trimmingCharacters(in: .whitespaces) == ""
                        
                        //TODO: Edit message
                        let warningAlert = self.model.createAlert(title: isBlank ? "Both fields must be filled in" : "This card is already in \(ContentModel.collections[self.collectionId!].title)", message: nil, style: .alert, isWarning: true)
                        
                        self.present(warningAlert, animated: true)
                    }
                    else {
                        ContentModel.collections[self.collectionId!].cards[cardId!].front = front!
                        ContentModel.collections[self.collectionId!].cards[cardId!].back = back!
                        
                        self.filteredCards[selectedRowIndex] = ContentModel.collections[self.collectionId!].cards[cardId!]
                        
                        if self.searchController.searchBar.text != nil && self.searchController.searchBar.text != "" && !self.filteredCards[selectedRowIndex].front.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                            
                            self.filteredCards.remove(at: selectedRowIndex)
                        }
                        
                        self.model.save()
                        self.tableView.reloadData()
                    }
                }))
                self.present(alert, animated: true)
            }
            success(true)
        }
        
        edit.image = UIImage(systemName: "pencil")
        
        // TODO: move remove function into contentModel
        let remove = UIContextualAction(style: .destructive, title: "") { (action, view, success:(Bool) -> Void) in
            
            let selectedRowIndex = indexPath.row
            
            let cardId = ContentModel.collections[self.collectionId!].cards.firstIndex { card in
                card.front == self.filteredCards[selectedRowIndex].front &&
                card.back == self.filteredCards[selectedRowIndex].back
            }
            
            if self.collectionId != nil && cardId != nil {
                
                let deleteAlert = self.model.createAlert(title: "Delete this card?", message: "Are you sure you want to delete this card?", style: .alert)
                            
                // Remove action
                deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    
                    ContentModel.collections[self.collectionId!].cards.remove(at: cardId!)
                    self.filteredCards.remove(at: selectedRowIndex)
                    
                    self.model.save()
                    self.tableView.reloadData()
                    
                    if ContentModel.collections[self.collectionId!].cards.count < 1 {
                        self.messageLabel.alpha = 1
                    }
                }))
                
                self.present(deleteAlert, animated: true)
            }
            success(true)
        }

        remove.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [remove, edit])
    }
}
