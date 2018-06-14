//
//  AnnouncementViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/19/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AnnouncementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var Messages: [[String:String]] = []
    var SingleMessege:[String:String]!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    
    @IBOutlet weak var Add: UIBarButtonItem!
    @IBAction func AddEvent(_ sender: UIButton) {
    }
    var ReversedMessages: [[String:String]] = []
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! customTableViewCell
     cell.cellview.layer.cornerRadius = cell.cellview.frame.height/2
        cell.Rowlabel.text = Messages[indexPath.row]["MessegeTitle"]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    @IBOutlet weak var mytable: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id {
            case "MsgSegue":
                if let Announcement = segue.destination as? AddAnnouncementViewController{
                    let selectedRow = self.mytable.indexPathForSelectedRow?.row
                    Announcement.Message = Messages[selectedRow!]
                    Announcement.Userid = Userid
                    Announcement.privilge = privilge
                }
            case "toAddAnnoucement":
                if let Announcement = segue.destination as? AddAnnouncementViewController{
                    Announcement.Userid = Userid
                    Announcement.privilge = privilge
                }
            case "toMain":
                if let mainview = segue.destination as? ViewController {
                    mainview.userID = Userid
                }
                
            default:
                break
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytable.delegate = self
        self.mytable.dataSource = self
        checkAuthToAddEvent()
       downloadTheMesseges()
        
    }
    //get the messages from firebase
    func downloadTheMesseges(){
        ref = Database.database().reference()
        handle = ref.child("message").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String:String]
            {   self.SingleMessege = ["key":"\(snapshot.key)" ,"MessegeTitle":item["MessegeTitle"]!,"MessageDetail":item["MessageDetail"]!]
                
                self.ReversedMessages.append(self.SingleMessege)
                
            }
            self.Messages = Array(self.ReversedMessages.reversed())
            self.mytable.reloadData()
        })
    }

    
    // check the authority
    func checkAuthToAddEvent(){
        if(privilge == true)
        {
            Add.isEnabled = false
        }
    }


}
