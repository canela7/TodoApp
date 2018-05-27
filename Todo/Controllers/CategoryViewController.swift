//
//  CategoryViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/25/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController  {
    
    let realm = try! Realm()

    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
        
        tableView.separatorStyle = .none
        
      
    }

    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1 //NIL COALESCING OPERATOR, if category is nil just return 1, if not then return the count
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //this is going to tap inside the cell that gets created inside our super class cell
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            //"FF5855" is the default color thats if categoryArray does not have a color
            cell.backgroundColor = UIColor(hexString: category.color)
            
        }else {
            cell.textLabel?.text = "No Categories added yet"
            cell.backgroundColor = UIColor(hexString: "FF5855")
        }
  
        return cell;
    }
    
    //MARK: - DELETE DATA FROM SWIPE
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
        
    }
    
    //MARK: - Data Manipulation  Methods
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        //reload data for the new item added to show up inside tableview
        self.tableView.reloadData();
    }
    
    
    //built in paramter Item.fetchRequest(), if there is no input inside the function when called i.e in viewdidload method
    func loadCategories(){
        
        //here realm.object auto update, fetching data from realm
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        //var global access used to use inside each scope
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //Category is the Entry datamodel core data.
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}



