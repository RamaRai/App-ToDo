//
//  todoListTableViewController.swift
// Keywords - CoreData, Table View, Array
//            Add, Update and delete Array/CoreData item/Record
//  ToDo App - Create a list of ToDo tasks list
//  to CoreData and fetch the data from CoreData to table
//  unsorted list
//
//  Created by Rama Rai on 2019-05-13.
//  Copyright © 2019 Rama. All rights reserved.
//

import UIKit
import CoreData

//Table View Controller, Search Bar delegate
class todoListTableViewController: UITableViewController,UISearchBarDelegate {
   
    //declaring delegate to be the Application's app delegate by default
    let delegate = UIApplication.shared.delegate as! AppDelegate
    //Array to create Task List
    var todoList = [ToDo]()
    
    //Function to add new task to list
    @IBAction func addNewTask(_ sender: Any) {
        //alert pop up window
    let alert = UIAlertController.init(title: "Add New Task", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new task"
            textField = alertTextField
        }
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            let newTodo = ToDo(context: self.delegate.persistentContainer.viewContext)
            newTodo.task = textField.text
            self.delegate.saveContext()
            self.fetch()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    // Update function called to update existing task selected from table
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Alert is pop up window
        let alert = UIAlertController.init(title: "Update the Task", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.text = self.todoList[indexPath.row].task
            textField = alertTextField
        }
        
        let action = UIAlertAction.init(title: "Update", style: .default) { (action) in
            self.todoList[indexPath.row].task = textField.text
            self.delegate.saveContext()
            self.fetch()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //Function to search Task from the existing list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetch()
        }
        else{
        let fetchRequest : NSFetchRequest = ToDo.fetchRequest()
        //predicate condition CONTAINS and [c] any case upper or lower
        let predicate = NSPredicate.init(format: "task CONTAINS [c] %@", searchText)
        
        //perform fetch using predicate condition
        fetchRequest.predicate = predicate
        do {
        todoList = try delegate.persistentContainer.viewContext.fetch(fetchRequest)
            tableView.reloadData()
        
        }catch{
            
        }
        }
        
    }
    
    //Function to fetch the record data from CoreData - Context View and load the table
    //with fresh data updated data
    func fetch ()  {
        let fetchRequest : NSFetchRequest = ToDo.fetchRequest()
        do {
         todoList = try delegate.persistentContainer.viewContext.fetch(fetchRequest)
            tableView.reloadData()
            
        }catch{
            
        }
        
        
    }
    
    //Intial View
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    //Number Sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    
    //Number of rows in table (or items in Task list)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return todoList.count
    }

//Title or content of each reuseable cell in table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

      cell.textLabel?.text = todoList[indexPath.row].task

        return cell
    }
  

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  

   
    // Override to support editing the table view.
    //Dealete module to delete any selected row or item from the task list in table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
           delegate.persistentContainer.viewContext.delete(todoList[indexPath.row])
            delegate.saveContext()
            fetch()
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //Not available in this version
        }    
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
