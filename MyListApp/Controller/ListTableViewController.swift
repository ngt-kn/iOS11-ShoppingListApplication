//
//  ListTableViewController.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {
    
    let realm = try! Realm()  // initialize realm
    var listItem : Results<ListItem>?  // declare a new object
    
    // set up for segue
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if count != nil, return count. Else return 1.
        return listItem?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        // if itemName != nil add itemName to list. else list is empty
        cell.textLabel?.text = listItem?[indexPath.row].itemName ?? "Please add an item"

        return cell
    }

    //Mark: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Delete item from list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let delItem = listItem?[indexPath.row]{
                do {
                    try realm.write{
                        realm.delete(delItem)
                    }
                    
                } catch {
                    print("Error, \(error)")
                }
            }
            tableView.reloadData()
        }
    }
    
    //MARK: Add items
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var nameTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // if selectedCategory != nil, create a new object and append
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = ListItem()
                        newItem.itemName = nameTextField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item, \(error)")
                }
            }
            // Reload the table
            self.tableView.reloadData()
        }
        
        
        // Add text field for itemName
        alert.addTextField { (name) in
            name.placeholder = "Enter Item Name"
            nameTextField = name
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - data manipulation methods
    
    // Load objects from realm
    func loadItems() {
        listItem = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        
        tableView.reloadData()
        
    }



}
