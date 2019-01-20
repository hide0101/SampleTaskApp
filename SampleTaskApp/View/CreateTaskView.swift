//
//  CreateTaskView.swift
//  SampleTaskApp
//
//  Created by 小森英明 on 2019/01/20.
//  Copyright © 2019 hide0101. All rights reserved.
//

import UIKit

/*
 CreateTaskViewControllerへユーザーインタラクションを伝達するためにProtocolです
*/
protocol CreateTaskViewDelegate: class {
    func createView(taskEditting view: CreateTaskView, text: String)
    func createVeiw(deadlineEditting view: CreateTaskView, deadline: Date)
    func createView(saveButtonDidTap view: CreateTaskView)
}
class CreateTaskView: UIView {
    
    // タスク内容を入力するUITextField
    private var taskTextField: UITextField!
    // 締切時間を表示するUIPickerView
    private var datePicker: UIDatePicker!
    // 締切時間を入力するUITextField
    private var deadlineTextField: UITextField!
    // 保存ボタン
    private var saveButton: UIButton!
    
    weak var delegate: CreateTaskViewDelegate?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        taskTextField = UITextField()
        taskTextField.delegate = self
        taskTextField.tag = 0
        taskTextField.placeholder = "予定を入れてください"
        addSubview(taskTextField)
        
        deadlineTextField = UITextField()
        deadlineTextField.tag = 1
        deadlineTextField.placeholder = "期限をいれてください"
        addSubview(deadlineTextField)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        /*
         UITextFieldが編集モードになった時に、キーボードではなく、UIDatePickerになるようにしている
        */
        deadlineTextField.inputView = datePicker
        
        saveButton = UIButton()
        saveButton.setTitle("保存する", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 4.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(saveButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        /*
         saveボタンが押された時に呼ばれるメソッド
         押したという情報をCreateTaskViewControllerへ伝達している
        */
        delegate?.createView(saveButtonDidTap: self)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        /*
         UIDatePickerの値が変わった時に呼ばれるメソッド
         sender.dateがユーザーが選択した締切日時で、DateFormatterを用いてStringに変換し、
         deadlineTextField.textに代入している
         また、日時の情報をCreateTaskViewControllerｎへ伝達している
        */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let deadlineText = dateFormatter.string(from: sender.date)
        deadlineTextField.text = deadlineText
        delegate?.createVeiw(deadlineEditting: self, deadline: sender.date)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskTextField.frame = CGRect(x: bounds.origin.x + 30, y: bounds.origin.y + 30 , width: bounds.size.width - 60, height: 50)
        deadlineTextField.frame = CGRect(x: taskTextField.frame.origin.x, y: taskTextField.frame.maxY + 30, width: taskTextField.frame.size.width, height: taskTextField.frame.size.height)
        let saveButtonSize = CGSize(width: 100, height: 50)
        saveButton.frame = CGRect(x: (bounds.size.width - saveButtonSize.width) / 2, y: deadlineTextField.frame.maxY + 20, width: saveButtonSize.width, height: saveButtonSize.height)
    }
}

extension CreateTaskView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            /*
             textField.tagで識別している
             もしtagが0のとき、textField.textすなわち、ユーザーが入力したタスク内容の文字を
             CreateTaskViewControllerに伝達している
            */
            delegate?.createView(taskEditting: self, text: textField.text ?? "")
        }
        return true
    }
    
}
