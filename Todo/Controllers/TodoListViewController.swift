//
//  ViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/22/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController
{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        //when we do call loadITEMS we're certain that we've already got a value for out selectedCategory
        didSet{
            loadItems()
        }
        
    }
    
//     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //UserDefaults - An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
    ///standard is a property inside UserDefaults - Returns the shared defaults object.
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
       // loadItems()
      
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //check if true, if so then set it to checkmark else none.
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        

        return cell;
    }
    
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //to reomve item using core data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
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
           
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        //Item is the Entry datamodel core data.
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving context \(error)")
                }
            }
       
           //reload data for the new item added to show up inside tableview
            self.tableView.reloadData();
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    

    
    
    //built in paramter Item.fetchRequest(), if there is no input inside the function when called i.e in viewdidload method
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
        tableView.reloadData()
    }
    
 
}

//MARK: - Search Bar Methods

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        print(searchBar.text!)
//
//        //NSPREDICATE USED TO QUERY/FILTER ITEMS
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//       // request.predicate = predicate
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//
//        //request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request, predicate: predicate)
//
////        do{
////            itemArray = try context.fetch(request)
////        }catch{
////            print("Error fetching data from context \(error)")
////        }
////
////        tableView.reloadData()
//
//    }
//
//
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems() //get all the items back if the search bar is empty
//
//            //ask the dispatch to run code inside the main thread, and run that
//            DispatchQueue.main.async {
//                //keyboard and cursor disappers after we dont have any text inside the search bar
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//
//}

















