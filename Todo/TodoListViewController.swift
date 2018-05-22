//
//  ViewController.swift
//  Todo
//
//  Created by Brian Canela on 5/22/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController
{

    var itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell;
    }
    
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
        
        
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
            print(textField.text!)
            
            self.itemArray.append(textField.text!)
            
            //reload data for the new item added to show up inside tableview
            self.tableView.reloadData();
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    



}

