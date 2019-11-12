//
//  Task.swift
//  ToDo-Firebase
//
//  Created by Алексей on 12/11/2019.
//  Copyright © 2019 Alexey Makarov. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    
    // Первый инициализатор чтобы создать локально объект
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
     // Второй инициализатор чтобы извлечь из БД
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title": title, "userId": userId, "completed": completed]
    }
    
}
