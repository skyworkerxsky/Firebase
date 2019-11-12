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
        
        let taskTitle = tasks[indexPath.row].title // Получаем заголовки
        cell.textLabel?.text = taskTitle
        
        return cell
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
