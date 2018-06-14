//
//  SignInViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/22/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import  Firebase
import CoreData

class SignInViewController: UIViewController {
     var ref: DatabaseReference!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var signInUp: UISegmentedControl!
    @IBOutlet weak var registerlabel: UIButton!
    // temporary values for username and password from Core Data
    var TempUserName:String!
    var TempPassword:String!
    var isFirstTimeLogin = 0
    // get the user id from firebase
    var userid:String!
    // choose the segment
    @IBAction func SwitchINUp(_ sender: UISegmentedControl) {
        if signInUp.selectedSegmentIndex == 0 {
            UserEmail.isHidden = false
            Password.isHidden = false
            signIn.isHidden = false
            Name.isHidden = true
            registerlabel.isHidden = true
        }
        if signInUp.selectedSegmentIndex == 1
        {
           Name.isHidden = false
            signIn.isHidden = true
            registerlabel.isHidden = false
            
        }
    }
    @IBAction func Register(_ sender: UIButton) {
        if Name.text! != "" {
            if UserEmail.text! != ""{
                if Password.text! != ""{
                     Auth.auth().createUser(withEmail: UserEmail.text!, password: Password.text!, completion: { (user, error) in
                        if error != nil {
                            self.createErrorMessage(errorMessage: "\(error)")
                            return
                        }
                        // add the user ro datbase
                   
                         self.ref = Database.database().reference()
                        let value = ["name": self.Name.text!, "email": self.UserEmail.text!,"privilge": "0"]
                      self.ref.child("users").child((user?.uid)!).setValue(value)
                     })
                }
        }
       
        }
    }
    @IBAction func SignIn(_ sender: UIButton) {
        let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
        Auth.auth().signIn(withEmail: UserEmail.text!, password: Password.text!) { (user, error) in
            if user != nil {
                
                // get userid
                self.userid = Auth.auth().currentUser?.uid 
               
                // call save to core dats
                self.saveCoreData(userID: self.UserEmail.text!,password: self.Password.text!)
                //perform segue
                self.performSegue(withIdentifier: "ToMainView", sender: self)
                self.postToken(Token: token)
                
            }
            else
            {
                if let myerror = error?.localizedDescription
                {
                     self.createErrorMessage(errorMessage: "\(myerror)")
                }else{
                self.createErrorMessage(errorMessage: "Wrong Email or Password")
                }}
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id {
            case "ToMainView":
                if let MainViewController = segue.destination as? ViewController{
                    if(userid != nil)
                    {MainViewController.userID = userid
                    }
                   
                }
                
            default:
                break
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserEmail.placeholder = "Email"
        Password.placeholder = "Password"
        Name.placeholder = "Name"
        Password.isSecureTextEntry = true
        registerlabel.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(isFirstTimeLogin == 0){
        fetchCoreData()
            signFromfetch()}
        
        
    }

    func postToken(Token:[String:AnyObject]){
        print("FCM Token: \(Token)")
        let dbRef = Database.database().reference()
        dbRef.child("fcmToken").child(Messaging.messaging().fcmToken!).setValue(Token)
    }
    

    func createErrorMessage(errorMessage: String){
        let alert = UIAlertController(title: "Worng Entry", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:  { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func fetchCoreData(){
        // core Data delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               TempUserName = data.value(forKey: "userName") as! String
               TempPassword = data.value(forKey: "password") as! String
            }
        } catch {
            
            print("Failed")
        }
        
    }
    func saveCoreData(userID: String ,password: String){
        // core Data delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(userID, forKey: "userName")
        newUser.setValue(password, forKey: "password")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func signFromfetch(){
        if(TempUserName != nil && TempPassword != nil){
        Auth.auth().signIn(withEmail: TempUserName, password: TempPassword) { (user, error) in
            if user != nil {
                // get userid
                self.userid = Auth.auth().currentUser?.uid                
                self.performSegue(withIdentifier: "ToMainView", sender: self)
            }
            else
            {
                if let myerror = error?.localizedDescription
                {
                    self.createErrorMessage(errorMessage: "\(myerror)")
                }else{
                    self.createErrorMessage(errorMessage: "Wrong Email or Password")
                }}
            }
        }
    }

}
