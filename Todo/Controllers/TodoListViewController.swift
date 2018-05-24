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

    var itemArray = [Item]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //UserDefaults - An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
    ///standard is a property inside UserDefaults - Returns the shared defaults object.
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
                
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
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        
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
           
            let newItem = Item();
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
          
            self.saveItems()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        //econde the itemArray, save.
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error trying to save, the error \(error)")
        }
        //reload data for the new item added to show up inside tableview
        self.tableView.reloadData();
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do{
                 itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error \(error)")
            }
        }
        
        
    }
    



}

