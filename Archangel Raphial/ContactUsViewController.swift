//
//  ContactUsViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/4/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import MapKit

class ContactUsViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var churchDetail: UITextView!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = contactUsData()
        churchDetail.text = data.message
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(data.address, completionHandler: {(placmarks: [CLPlacemark]?,error : Error?) in
            if placmarks != nil {
                let topres = placmarks?[0]
                let placmarks = MKPlacemark(placemark: topres!)
              
             let region = MKCoordinateRegionMakeWithDistance(placmarks.coordinate, 500, 500)
           
        
        let annotation = MKPointAnnotation()
        annotation.title = "Archangel Raphael Coptic Orthodox Church"
        annotation.subtitle = data.address
        annotation.coordinate = placmarks.coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.mapType = MKMapType.standard
        self.mapView.setRegion(region, animated: true)
                 }})
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
    




