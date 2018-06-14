//
//  AddEvent.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/18/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import  FirebaseDatabase
import Firebase
import FirebaseRemoteConfig

class AddEvent: UIViewController,UITextFieldDelegate {
    var EventDate: String!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var EventDetails: UITextView!
    var ref: DatabaseReference!
//   var remoteConfig = RemoteConfig.remoteConfig()
   
    
    @IBAction func SaveEvent(_ sender: UIButton)
    {
        if EventName.text != ""
        {
            
        if  EventDetails.text != "" {
            let details = "\(EventName.text!) "  + ": " + "\(EventDetails.text!)"
            let Eventinstance: [String: String] = [
                "date": EventDate,
                "details": details
            ]

             ref.child("event").childByAutoId().setValue(Eventinstance)
            performSegue(withIdentifier: "toCal", sender: self)
            }
        }
        else
        {
           createErrorMessage(errorMessage: "Please Enter valid Event")
            
        }
    }
    
    // create error message for specific String
    func createErrorMessage(errorMessage: String){
        let alert = UIAlertController(title: "Worng Entry", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:  { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.EventName {
            textField.resignFirstResponder()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EventName.resignFirstResponder()
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         self.EventName.delegate = self
        // refrence for the dataBase
        ref = Database.database().reference()
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch  id {
          
            case "toCal":
                if let calview = segue.destination as? calendarViewController {
                    calview.Userid = Userid
                    calview.privilge = privilge
                }
            default:
                break
            }
        }
    }
    



}
