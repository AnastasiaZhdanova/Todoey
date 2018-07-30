//
//  CategoryViewController.swift
//  Todoey
//
//  Created by student on 7/30/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categorysArray = [Category]()
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategorys()
    }

       //MARK: -  TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorysArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategorysCell", for: indexPath)
        
    //    let category = categorysArray[indexPath.row]
        
        cell.textLabel?.text = categorysArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     /*   saveCategorys()
        
        tableView.deselectRow(at: indexPath, animated: true)*/
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categorysArray[indexPath.row]
        }
    }
    
      //MARK: - Data Manipulation Methods
    func saveCategorys(){
        
        do {
            
            try context.save()
        } catch {
            print("Error saving conext \(error)")        }
        
        self.tableView.reloadData()
        
    }
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categorysArray = try context.fetch(request)
            tableView.reloadData()
        } catch{
            print("Error fetching data from context \(error)")
        }
    }
    
    
      //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new ToDo Categoty", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categorysArray.append(newCategory)
            
            self.saveCategorys()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
