//
//  CreateTaskViewController.swift
//  SampleTaskApp
//
//  Created by 小森英明 on 2019/01/20.
//  Copyright © 2019 hide0101. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    fileprivate var createTaskView: CreateTaskView!
    
    fileprivate var dataSouce: TaskDataSource!
    fileprivate var taskText: String?
    fileprivate var taskDeadline: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        /*
         CreateTaskViewを生成し、デリゲートにselfをセットしている
        */
        createTaskView = CreateTaskView()
        createTaskView.delegate = self
        view.addSubview(createTaskView)
        // TaskDataSourceを生成
        dataSouce = TaskDataSource()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // CreateTaskViewのレイアウトを決めている
        createTaskView.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right, height: view.frame.size.height - view.safeAreaInsets.bottom)
    }
    /*
     保存が成功したときのアラート
     保存が成功したら、アラートを出し、前の画面に戻っている
    */
    fileprivate func showSaveAlert() {
        let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     締切日が未入力のときのアラート
     締切日が未入力の時に保存してほしくない
    */
    fileprivate func showMissingTaskDeadlineAlert() {
        let alertController = UIAlertController(title: "締切日を入力してください", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

// CreateTaskViewDelegateメソッド
extension CreateTaskViewController: CreateTaskViewDelegate {
    func createView(taskEditting view: CreateTaskView, text: String) {
        /*
         タスク内容を入力している時に呼ばれるデリゲートメソッド
         CreateTaskViewからタスク内容を受け取り、taskTextに代入している
        */
        taskText = text
    }
    
    func createVeiw(deadlineEditting view: CreateTaskView, deadline: Date) {
        /*
         締切日時を入力している時に呼ばsれるデリゲートメソッド
         CreateTaskViewから締切日時をうけとり、taskDeadLineに代入している
        */
        taskDeadline = deadline
    }
    
    func createView(saveButtonDidTap view: CreateTaskView) {
        /*
         保存ボタンが押された時に呼ばれるデリゲートメソッド
         taskTextがnilだった場合showMissingTaskTextAlert()を呼び、
         taskDeadlineがnilだった場合showMissingTaskDeadlineAlert()を呼んでいる
         どちらもnilでなかった場合に、taskText,taskDeadlineからTaskを生成し、
         dataSource.save(task: task)を呼んで、taskを保存している
         保存完了後 showSaveAlert()をよんでいる
        */
        guard let taskText = taskText else {
            showMissingTaskDeadlineAlert()
            return
        }
        guard let taskDeadline = taskDeadline else {
            showMissingTaskDeadlineAlert()
            return
        }
        let task = Task(text: taskText, deadline: taskDeadline)
        dataSouce.save(task: task)
        showSaveAlert()
    }
}
