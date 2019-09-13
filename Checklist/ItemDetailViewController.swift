//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Bob on 13/08/2019.
//  Copyright © 2019 Bob. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class { // сделали так, чтобы работал только с классами. Создаем свой кастомный протокол с двумя методами. Any controller that wants to get a new checklist item back needs to implement this protocol.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)//controller - just taking this AddItemTableViewController(ItemDetailV). INDICATE THAT ADD ACTION WAS CANCELED.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)//indicate that the user has added the item.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem)//indicate that the user has edited the item.
} // ПЛОХО ПОНЯТНО КАК ОН РАБОТАЕТ И ЗАЧЕМ НУЖЕН. 143 УРОК.

class ItemDetailViewController: UITableViewController {
    
    weak var delegate: ItemDetailViewControllerDelegate? //НЕ ПОНЯТНО. ТЕПЕРЬ КОГДА МЫ ВЫЗЫВАЕМ ЭТУ ПРОПЕРТИ(delegate), МЫ МОЖЕМ ВЗЯТЬ МЕТОДЫ ТОГО ПРОТОКОЛА, К КОТОРОМУ ОНА ПРИВЯЗАНА. 143 УРОК
    weak var todoList: TodoList? //создаем проперти для passing data.
    weak var itemToEdit: CheckListItem? //создаем проперти для passing data.
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var textfield: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self) //delegate?-если это не делегат, то он не будет вызван. ПОЧЕМУ SELF????
        //call these delegate methods from this view controller
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textfield.text { //это Edit case
            item.text = text // сделали текст item такой, который мы ввели.
            delegate?.itemDetailViewController(self, didFinishEditing: item ) //self - это вью контрллер.
        } else {
        if let item = todoList?.newTodo() { //create a new own checklist item
          if let textFiledText = textfield.text {
                item.text = textFiledText //просто присвоили item значение текста, который ввели
            }
            item.checked = false //установили изначально без галочки
            delegate?.itemDetailViewController(self, didFinishAdding: item)//с помощью этого протокола заканчиваем ввод.
          }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit { //check to see if we are editing. We are editing if we have an item to edit! если грубо говоря на кнопку i нажали, то мы изменяем текст в этой ячейке (textfield.text = item.text). Туда вставляется текст айтема (который берется через CheckListItem)
            title = "Edit Item" //теперь вместо Title в навигейшн баре у нас Edit Item
            textfield.text = item.text
            addBarButton.isEnabled = true //сделали кнопку Done изначально доступной для нажатия
        }
        navigationItem.largeTitleDisplayMode = .never //изменяем в навигейшн контроллере размер текста
        textfield.delegate = self //говорю текстфилду, что я делегируюсь от него. не понятно???
    }
    
    override func viewWillAppear(_ animated: Bool) { //для того, чтобы клавиатура сама появлялась при переходе на новое вью.
        textfield.becomeFirstResponder() //сделали текстфилд first responder -ом. не понятно???
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { //метод позволяет решать может ли быть выделен роу или нет.
        return nil //сделали так, чтобы мы не могли выделить ячейку, в котором лежит textField
    }
}

extension ItemDetailViewController: UITextFieldDelegate { //перед тем как писать метод, нужно сказать текстфилду, что я делегируюсь от него
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //реализуем текстфилд метод, которой описан выше (textfield.delegate = self)
        textfield.resignFirstResponder() //передаем фёрст респондер статус
        return false // возвращаем bool значение. ЭТО ДЛЯ ТОГО, ЧТОБЫ УБРАТЬ ВНИЗ КЛАВУ ПОСЛЕ ТОГО, КАК НАЖАДЛИ DONE. 
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, //current text in textField that hasn't been changed yet
              let stringRange = Range(range, in: oldText) else { //диапазон строки. типа длина ее получается.
            return false //елси кто-то из них(oldText, stringRange) nil, то возращаем false.
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)//текст, который вводит юзер. делается на случай, если пользователь вставляет какой-то текст из буфера.
        if newText.isEmpty {
            addBarButton.isEnabled = false //если нет текста, то кнопка Add не активна.
        } else {
            addBarButton.isEnabled = true
        }
        return true
    }
}
