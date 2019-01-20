//
//  Task.swift
//  SampleTaskApp
//
//  Created by 小森英明 on 2019/01/20.
//  Copyright © 2019 hide0101. All rights reserved.
//

import Foundation

class Task {
    // タスクの内容
    let text: String
    // タスクの締切時間
    let deadline: Date
    /*
    引数からtextとdeadLineを受け取り
    Taskを生成するイニシャライザメソッド
    */
    init(text: String, deadline: Date) {
        self.text = text
        self.deadline = deadline
    }
    /*
    引数のdictionaryからTaskを生成するイニシャライザ
    userDefaultsで保存したdictionaryから生成することを目的としている
    */
    init(from dictionary: [String: Any]) {
        self.text = dictionary["text"] as! String
        self.deadline = dictionary["deadline"] as! Date
    }
}
