//
//  ChatViewController.swift
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Now Chat"
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }

    func loadMessages() {
        
        db.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
//                self.errorAlert(title: "Loading Message Error", e.localizedDescription)
                
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                                
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indxPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indxPath, at: .top, animated: true)
                            }
                        }
                    }
                }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text == "" { return }
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: ["sender":messageSender,
                                                         "body": messageBody,
                                                         "date": Date().timeIntervalSince1970]) { (error) in
                
                if let e = error { self.errorAlert(title: "Chat Error", e.localizedDescription) }
                else {DispatchQueue.main.async {self.messageTextfield.text = "" }
                }
            }
        }
    }
    
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
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.blue)
            
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
       
        return cell
    }
    
}
