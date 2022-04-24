import RealmSwift
import UIKit
import SwiftUI

class EditViewController: UIViewController {
    public var itemId: String!
    public var editingHandler: (() -> Void)?
    public var item:ToDoListItem!

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    private let realm = try! Realm()

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
       }()


    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        item = realm.objects(ToDoListItem.self).where {
            $0.id == itemId}.first!
        textField.text = item?.item
        datePicker.setDate(item.date, animated: true)


        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))

    }
    
    @objc func didTapDoneButton() {
        if let text = textField.text, !text.isEmpty {
            try! realm.write {
                item.item = text
                item.date = datePicker.date
            }
            editingHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
       else {
            print("Add something")
            }
    }
}
