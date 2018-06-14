

import UIKit
import FirebaseDatabase

class AddAnnouncementViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var AnnounceTitle: UITextField!
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var Message: [String:String]!
    var MessageDetail:[String]!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    var MessageUploaded: [String:String]!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    
    @IBAction func send(_ sender: UIButton) {
        if AnnounceTitle.text != ""
        {
            
            if  details.text != "" {
                MessageUploaded = ["MessegeTitle": AnnounceTitle.text!,"MessageDetail": details.text!]
         ref.child("message").childByAutoId().setValue(MessageUploaded)
        AnnounceTitle.text = ""
        details.text = ""
                performSegue(withIdentifier: "toAnnoucement", sender: self)
            }
        }
        else
        {
            createErrorMessage(errorMessage: "Please Enter valid Announcement")
        }
    }
    
    
    @IBAction func edit(_ sender: UIButton) {
        if AnnounceTitle.text != ""
        {
            
            if  details.text != "" {
                MessageUploaded = ["MessegeTitle": AnnounceTitle.text!,"MessageDetail": details.text!]
                ref.child("message").child(Message["key"]!).setValue(MessageUploaded)
                AnnounceTitle.text = ""
                details.text = ""
                performSegue(withIdentifier: "toAnnoucement", sender: self)
            }
        }
        else
        {
            createErrorMessage(errorMessage: "Please Enter valid Announcement")
        }
    }
    
    
    func createErrorMessage(errorMessage: String){
        let alert = UIAlertController(title: "Worng Entry", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:  { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.AnnounceTitle {
            textField.resignFirstResponder()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AnnounceTitle.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          ref = Database.database().reference()
        self.AnnounceTitle.delegate = self
        
        checkButton()
        if (Message != nil){
           sendButton.isEnabled = false
        AnnounceTitle.text = Message["MessegeTitle"]
            details.text =  Message["MessageDetail"]}
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id {
            case "toAnnoucement":
                if let Announcement = segue.destination as? AnnouncementViewController
                {
                    Announcement.Userid = Userid
                    Announcement.privilge = privilge
                }

                
            default:
                break
            }
        }
    }
    func checkButton(){
        if(privilge == true)
        {   details.isEditable = false
            AnnounceTitle.isUserInteractionEnabled = false
            sendButton.isEnabled = false
            editButton.isEnabled = false
        }
    }
    
}
