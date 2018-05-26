//
//  CategoryViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/25/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    //have acces to our appdeleagate as an object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
    }

    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell;
    }
    
    
    
    //MARK: - Data Manipulation  Methods
    func saveCategories(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        //reload data for the new item added to show up inside tableview
        self.tableView.reloadData();
    }
    
    
    //built in paramter Item.fetchRequest(), if there is no input inside the function when called i.e in viewdidload method
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        //    let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        
        
        tableView.reloadData()
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    //MARK: - TableView Delegate Methods
 
    
    
}
