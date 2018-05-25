//
//  ViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/22/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController
{

    var itemArray = [Item]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //have acces to our appdeleagate as an object
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //UserDefaults - An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
    ///standard is a property inside UserDefaults - Returns the shared defaults object.
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        loadItems()
      
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //check if true, if so then set it to checkmark else none.
        cell.accessoryType = item.done ? .checkmark : .none
        

        return cell;
    }
    
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //to reomve item using core data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //var global access used to use inside each scope
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Now")
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //Item is the Entry datamodel core data.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
          
            self.saveItems()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
       
        do{
            try context.save()
        }catch{
           print("Error saving context \(error)")
        }
        
        //reload data for the new item added to show up inside tableview
        self.tableView.reloadData();
    }
    
    
    //built in paramter Item.fetchRequest(), if there is no input inside the function when called i.e in viewdidload method
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
    //    let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
          itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
 
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        print(searchBar.text!)
        
        //NSPREDICATE USED TO QUERY/FILTER ITEMS
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems() //get all the items back if the search bar is empty
            
            //ask the dispatch to run code inside the main thread, and run that
            DispatchQueue.main.async {
                //keyboard and cursor disappers after we dont have any text inside the search bar
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}

















