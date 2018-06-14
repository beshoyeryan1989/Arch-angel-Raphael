//
//  broadcastViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/5/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit

class broadcastViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    
    func getYoutube() {
        if let url = URL(string : "https://www.youtube.com/embed/live_stream?channel=UCmr3L3Wzc1SqhLVM4qEONbQ&autoplay=1"){
            do {
                self.webView.loadRequest(URLRequest(url: url))
            }
            catch {}
            
        }
        
    }
        
    @IBAction func previousVideos(_ sender: Any) {
        let youtubeId = "UCmr3L3Wzc1SqhLVM4qEONbQ"
        var url = URL(string:"youtube://\(youtubeId)")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string:"https://www.youtube.com/channel/\(youtubeId)")!
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        getYoutube()
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let id = segue.identifier{
                switch id {
                case "toMain":
                    if let mainview = segue.destination as? ViewController {
                        mainview.userID = Userid
                    }
                    
                default:
                    break
                }
            }

   
    }}

