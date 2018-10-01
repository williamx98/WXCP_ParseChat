//
//  ChatViewController.swift
//  WXCP_ParseChat
//
//  Created by Will Xu  on 9/30/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages: [PFObject] = []
    var currentUsername: String!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.current()?.username
        self.currentUsername = self.title
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 15
        tableView.separatorStyle = .none
        
        self.getMessages()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.getMessages()
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        sendMessage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        var identifier = "ChatCell"
        if let user = message["user"] as? PFUser {
            if (user.username! == self.currentUsername!) {
                identifier = "SelfCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatCell
        cell.messageLabel.text = message["text"] as? String
        cell.selectionStyle = .none
        cell.usernameLabel.text = "🤖"
        if let user = message["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        }
        return cell
    }
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                if (self.messages != messages) {
                    self.messages = messages
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {action in self.getMessages()}
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func sendMessage() {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("message saved")
                self.messageField.text = "";
                self.getMessages()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
