//
//  TaskDataSource.swift
//  SampleTaskApp
//
//  Created by 小森英明 on 2019/01/20.
//  Copyright © 2019 hide0101. All rights reserved.
//

import Foundation

class TaskDataSource: NSObject {
    // Task一覧を保存するArray UITableViewに表示させるためのデータ
    private var tasks = [Task]()
    // UserDefaultsから保存したTask一覧を取得している
    func loadData() {
        let userDefaults = UserDefaults.standard
        let taskDictionaries = userDefaults.object(forKey: "tasks") as? [[String : Any]]
        guard let t = taskDictionaries else { return }
        
        for dic in t {
            let task = Task(from: dic)
            tasks.append(task)
        }
    }
    // TaskをUserDefaultsに保存している
    func save(task: Task) {
        tasks.append(task)
        var taskDictionaries = [[String : Any]]()
        for t in tasks {
            let taskDictionary: [String : Any] = ["text" : t.text, "deadline": t.deadline]
            taskDictionaries.append(taskDictionary)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(taskDictionaries, forKey: "tasks")
        userDefaults.synchronize()
    }
    // Taskの総数を返している。UITableViewのCellのカウントに使用する
    func count() -> Int {
        return tasks.count
    }
    /*
     指定したindexに対応するTaskを返している
     indexにはUITableViewのIndexPath.rowがくることを想定している
    */
    func data(at index: Int) -> Task? {
        if tasks.count > index {
            return tasks[index]
        } else {
            return nil
        }
    }
}
