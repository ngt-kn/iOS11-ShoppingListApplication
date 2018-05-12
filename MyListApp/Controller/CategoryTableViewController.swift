//
//  CategoryTableViewController.swift
//  MyListApp
//
//  Created by Kenneth Nagata on 5/12/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns count if != nil, else returns 1
        return categories?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Sets text to categoryName if != nil, else default message
        cell.textLabel?.text = categories?[indexPath.row].categoryName ?? "Use edit to add category."
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //MARK: - data manipulation methods
    
    // Save data to Realm persistant store
    func save(category: Category) {
        
        // write data to realm
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving to realm \(error)")
        }
        
        // reload the table with new data
        tableView.reloadData()
    }
    
    // Load data from Realm persistant store
    func load() {
       
        // load categories from realm
        categories = realm.objects(Category.self)
        
        // reload tablevite
        tableView.reloadData()
        
    }
    
    func deleteCategory() {
        
    }
    
    // display an alert allowing user to add and delete categories
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit Categories", message: "", preferredStyle: .alert)
        
        let addCategory = UIAlertAction(title: "Add", style: .default) { (addCategory) in
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a name"
            textField = alertTextField
            
            
        }
        
        alert.addAction(addCategory)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    //Mark: tableview delegate methods
    
    // Segue to ListTableview for selected cell
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToListVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    

}
