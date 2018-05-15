//
//  ListTableViewController.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()  // initialize realm
    var listItem : Results<ListItem>?  // declare a new object
    
    // set up for segue
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
        
    }
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.categoryName
        
        guard let colorHex = selectedCategory?.color else {fatalError()}
  
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }

    //MARK: - Nav Bar Setup methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = UIColor(hexString: colorHexCode)
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor :
            ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if count != nil, return count. Else return 1.
        return listItem?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listItem?[indexPath.row] {
            cell.textLabel?.text = item.itemName
            
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((listItem!.count)) ){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = (listItem?[indexPath.row].done)! ? .checkmark : .none
        } else {
            
        }
      
        //cell.textLabel?.text = listItem?[indexPath.row].itemName ?? "Please add an item"
        
        
        return cell
    }

    //Mark: - delegate methods
    
    // Place checkmark on cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = listItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // After selection reset row color to default
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    // Delete item
    override func updateModel(at indexPath: IndexPath) {
        if let delItem = listItem?[indexPath.row]{
            do {
                try realm.write{
                    realm.delete(delItem)
                }

            } catch {
                print("Error, \(error)")
            }
        }
    }
}

//Mark: - Search bar methods
extension ListTableViewController: UISearchBarDelegate {
    
    // searchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        listItem = listItem?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemName", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}





