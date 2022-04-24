import RealmSwift
import UIKit
import SafariServices

class ToDoListItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            animateTable()
        }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return data.count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           cell.textLabel?.text = data[indexPath.row].item
           return cell
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
            
          let item = data[indexPath.row]

          guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
             return
          }

         vc.itemId = item.id
         vc.editingHandler = { [weak self] in self?.refresh()}
         vc.navigationItem.largeTitleDisplayMode = .never
         vc.title = item.item
         navigationController?.pushViewController(vc, animated: true)

      }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let item = data[indexPath.row]

                realm.beginWrite()
                realm.delete(item)
                try! realm.commitWrite()
                data = realm.objects(ToDoListItem.self).map({ $0 })
                table.reloadData()

            }
    }
    
    @IBAction func didTapAddButton() {
           guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
               return
           }
           vc.completionHandler = { [weak self] in
               self?.refresh()
           }
           vc.title = "New Item"
           vc.navigationItem.largeTitleDisplayMode = .never
           navigationController?.pushViewController(vc, animated: true)
       }

    func refresh() {
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.reloadData()
        }
    
    @IBAction func openLInk(_ sender: UIButton) {
        sender.backgroundColor = UIColor.tintColor
        sender.alpha = 0
        UIView .animate(withDuration: 0.3, animations: {
            sender.alpha = 1
        }, completion: { completed in
            if completed {
                sender.backgroundColor = UIColor.white
            }
        })
        
        let URL = URL(string: "https://www.google.com/")!
        let webVc = SFSafariViewController(url: URL)
        present(webVc, animated:true, completion: nil)
    }
    
    func animateTable() {
        table.reloadData()
        let cells = table.visibleCells
        
        let tableViewHeight = table.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delay = 0
        for cell in cells {
            UIView.animate(withDuration: 1.55, delay: Double(delay) * 0.05, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delay += 1
        }
}
    

}
