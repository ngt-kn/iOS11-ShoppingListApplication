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


        loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].categoryName ?? "Please add a category"
    
        return cell
    }
 


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // save item to realm
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    // Load categories from realm
    func loadCategory() {
        categories = realm.objects(Category.self)
        
        // reload the table
        tableView.reloadData()
        
    }
    
    func deleteCategory() {
        
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            self.saveCategory(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToListVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}





























