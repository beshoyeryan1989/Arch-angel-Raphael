//
//  ViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/3/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseMessaging

class ViewController: UIViewController {
    var count:Int!
    var userID:String!
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var privilge:Bool!
    
    
    @IBAction func goBackToSignIn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ReturnToSignIn", sender: self)
    }
    
    func logout()
    { count = 1
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id {
            case "ReturnToSignIn":
                if let SignInView = segue.destination as? SignInViewController
                {SignInView.isFirstTimeLogin = count
                }
            case "toCal":
                    if let calenderView = segue.destination as? calendarViewController{
                    calenderView.privilge = self.privilge
                    calenderView.Userid = self.userID
                }
            case "toMessage":
                if let Announcement = segue.destination as? AnnouncementViewController{
                    Announcement.privilge = self.privilge
                    Announcement.Userid = self.userID
                }
            case "toContactUs":
                if let contactUSview = segue.destination as? ContactUsViewController{
                    contactUSview.privilge = self.privilge
                    contactUSview.Userid = self.userID
                }
            case "toBroadcast":
                if let broadcastView = segue.destination as? broadcastViewController{
                    broadcastView.privilge = self.privilge
                    broadcastView.Userid = self.userID
                }
                
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logout()
        checkPrivilge()
      
    }
   
    func checkPrivilge(){
        ref = Database.database().reference()
        ref.child("users").child(userID!).observe(.value, with: { (snapshot) in
            let item = snapshot.value as? [String: String]
            let temp = Int(item!["privilge"]!)
            if(temp! > 0){
                self.privilge = false
                
            }
            else {
                self.privilge = true
            }
        }, withCancel: nil)
}

}
