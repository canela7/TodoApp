//
//  ViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/22/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController
{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        //when we do call loadITEMS we're certain that we've already got a value for out selectedCategory
        didSet{
            loadItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")
        }
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        title = selectedCategory?.name
    
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError()}
        
        
                
            navBar.barTintColor = navBarColor
        
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
            searchBar.barTintColor =  navBarColor
        
            
        
        
    }
    

    

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
           
            cell.textLabel?.text = item.title
            
            
        if let color = UIColor(hexString:selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
        }
            
            //check if true, if so then set it to checkmark else none.
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        

        return cell;
    }
    
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving data staus, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        //Item is the Entry datamodel core data.
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
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
    
    //MARK - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
        
    }
    
    
    
 
}



//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

















