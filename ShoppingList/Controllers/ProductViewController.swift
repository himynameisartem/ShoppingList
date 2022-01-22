//
//  ProductViewController.swift
//  ShoppingList
//
//  Created by Артем Кудрявцев on 21.01.2022.
//

import UIKit
import CoreData

class ProductViewController: UITableViewController {
    
    var productArray = [String]()
    var titleBar = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleBar
   
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        cell.textLabel?.text = productArray[indexPath.row]

        return cell
    }

    @IBAction func addButton(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новый товар", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Сохранить", style: .default) { (alert) in
            
            self.productArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Введите товар"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
