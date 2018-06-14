//
//  calendarViewController.swift
//  Archangel Raphial
//
//  Created by Beshoy on 8/8/17.
//  Copyright © 2017 BeshoyKaldas. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase
import  Firebase


class calendarViewController: UIViewController {
let formatter = DateFormatter()
    
    var eventsFromServer: [String:String]!
     var remoteConfig = RemoteConfig.remoteConfig()
    @IBOutlet weak var AddEventKey: UIButton!
    @IBOutlet weak var EventDetailTextfield: UITextView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    // coming from segue
    var privilge: Bool!
    var Userid: String!
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var currentDate: String!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        eventsFromServer = [:]
        // refrence for the dataBase
        ref = Database.database().reference()
        handle = ref.child("event").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String: String]
            {  // var key = item["date"]!
               // self.eventsFromServer["\(key)"]  = item["details"]
                // dispatchqueue
                DispatchQueue.global().asyncAfter(deadline: .now()) {
                    var key = item["date"]!
                    self.eventsFromServer["\(key)"]  = item["details"]
                    print(key)
                    print(self.eventsFromServer["\(key)"])
                }
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }
            }})

        setupCalendarView()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([ Date() ])
        // check privilge
        checkAuthToAddEvent()

        }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch  id {
            case "toAddEvent":
                if let EventViewController = segue.destination as? AddEvent {
                   EventViewController.EventDate = currentDate
                   EventViewController.Userid = Userid
                    EventViewController.privilge = privilge
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
    func setupCalendarView()
    {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //setup labeles
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "yyyy"
            self.year.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)
        }
    }
    //handle the dot for events
    func handleCellEvents(cell: CustomCell, cellState: CellState){
        formatter.dateFormat = "yyyy MM dd"
        cell.eventdotview.isHidden = !eventsFromServer.contains{$0.key == formatter.string(from: cellState.date)}
    }
        //handle the selected cell   
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validcell = view as? CustomCell else {return}
        if validcell.isSelected
        {
            validcell.selectedView.isHidden = false
        }
        else
        {
            validcell.selectedView.isHidden = true
        }
    }
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState){
        guard let validcell = view as? CustomCell else {return}

                  if cellState.isSelected
                  {
            validcell.dateLabel.textColor = UIColor.black
                  } else {
                    if cellState.dateBelongsTo == .thisMonth {
                        validcell.dateLabel.textColor = UIColor.white
                    }else {
                        validcell.dateLabel.textColor = UIColor.gray
                    }
        }
    
    }
    }


extension calendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}
extension calendarViewController: JTAppleCalendarViewDelegate {
    // Display cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell  = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        return cell
}
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
       let date = cellState.date
        formatter.dateFormat = "yyyy MM dd"
        currentDate = formatter.string(from: date)
       // print(currentDate)
        handleCellSelected(view: cell, cellState: cellState)
      handleCelltextColor(view: cell, cellState: cellState)
        getEventDetail(cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
       handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    func getEventDetail(cellState: CellState){
        formatter.dateFormat = "yyyy MM dd"
        EventDetailTextfield.text = eventsFromServer[formatter.string(from: cellState.date)]
        
    }
    
    
    // check the authority
    func checkAuthToAddEvent(){
        if(privilge == true)
        {
        AddEventKey.isEnabled = false
        }
    }
   // segue
    
    
   

}
