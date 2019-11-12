//
//  TasksViewController.swift
//  ToDo-Firebase
//
//  Created by Алексей on 06/11/2019.
//  Copyright © 2019 Alexey Makarov. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Advanced propeties
    var user: MyUser!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Получаем данные из Firebase
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in // отслеживаем значение, получаем snapshot
            
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = MyUser(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ref.removeAllObservers() // Удаляем наблюдателя
    }
    
    // MARK: Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // custom
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let task = tasks[indexPath.row]
        let taskTitle = task.title // Получаем заголовки
        let isCompleted = task.completed
        cell.textLabel?.text = taskTitle
        toogleCompletion(cell, isCompleted: isCompleted)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toogleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
        
        print("check")
    }
    
    func toogleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    // MARK: Actions
    @IBAction func addTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "save", style: .default) { [weak self] _ in
         
            // создаем задачу
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        let cansel = UIAlertAction(title: "cansel", style: .cancel, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cansel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}
