//
//  ChatViewController.swift
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [ Message(sender: "Joker", body: "Why so serious?"),
                                Message(sender: "Batman", body: "My parents died"),
                                Message(sender: "Joker", body: "Ha toh?")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Now Chat"
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

    @IBAction func sendPressed(_ sender: UIButton) {}
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            errorAlert(title: "Logout Error", signOutError.localizedDescription)
        }
      
    }

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = messages[indexPath.row].sender + " -->  " + messages[indexPath.row].body
//        cell.contentConfiguration = content
        let myMessage = messages[indexPath.row].sender + " -->  " + messages[indexPath.row].body
        cell.label.text = myMessage
        return cell
    }
    
}
