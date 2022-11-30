//
//  DetailViewController.swift
//  ToDue
//
//  Created by Mavis on 2022/11/13.
//

import UIKit
import EventKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var desciptionField: UITextField!
    
    @IBOutlet weak var priorityButton: UIButton!
    var titleText: String = ""
    var locationText: String = ""
    var descriptionText: String = ""
    var priority: String = "High"
    var isComplete: Bool = false
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var weekday: Int = 0
    var createDate: Date = Date()
    var dueDate: Date?
    var isNew: Bool = true
    var tag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let eventDate = dueDate {
            datePicker.setDate(eventDate, animated: true)
            isNew = false
        }
        
        titleField.text = titleText
        locationField.text = locationText
        desciptionField.text = descriptionText
        let highItem = UIAction(title: highConst) { (action) in
            
            self.priority = highConst;
            self.priorityButton.setTitle(highConst, for: .normal)
       }
        let mediumItem = UIAction(title: mediumConst) { (action) in
            
            self.priority = mediumConst;
            self.priorityButton.setTitle(mediumConst, for: .normal)
       }
        let lowItem = UIAction(title: lowConst) { (action) in
            
            self.priority = lowConst;
            self.priorityButton.setTitle(lowConst, for: .normal)
       }
        let menu = UIMenu(title: "Select", options: .displayInline, children: [highItem , mediumItem , lowItem])
        priorityButton.menu = menu
        priorityButton.showsMenuAsPrimaryAction = true
        self.priorityButton.setTitle(self.priority, for: .normal)
    }
    
    
    @IBAction func editTitle(_ sender: UITextField) {
        if let title = sender.text {
            self.titleText = title
        }
    }
    
    @IBAction func editLocation(_ sender: UITextField) {
        if let location = sender.text {
            self.locationText = location
        }
    }
    
    @IBAction func editDescription(_ sender: UITextField) {
        if let description = sender.text {
            self.descriptionText = description
        }
    }
    
    func getDateTimeFromDatePicker() {
        if let picker = self.datePicker {
            let components = picker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: picker.date)
            self.year = components.year ?? 0
            self.month = components.month ?? 0
            self.day = components.day ?? 0
            self.hour = components.hour ?? 0
            self.minute = components.minute ?? 0
            self.weekday = components.weekday ?? 0
        }
    }
    
    // viewWillDisappear will trigger the parent view when there ia a phone call
    // use WillMove instead
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        // This func will be called in 2 conditions:
        // 1: The detail view is added to the nav controller, parent -> nav controller
        // 2: The detail view is removed from the nav controller, parent -> nil
        // We only want the new event to be stored when user go back to the main view controller, which is the second condition
        if (parent == nil) {
            getDateTimeFromDatePicker()
            let event = Event(year: self.year,
                              month: self.month,
                              day: self.day,
                              hour: self.hour,
                              minute: self.minute,
                              weekday: self.weekday,
                              title: self.titleText,
                              description: self.descriptionText,
                              location: self.locationText, priority: self.priority,
                              isComplete: self.isComplete,
                              createDate: self.createDate)
            
            if let events = UserDefaults.standard.data(forKey: "events"){
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Event].self, from: events) {
                    var events2 = decoded
                    // access detail view by add button/existing cell
                    if (isNew) {
                        events2.append(event)
                        
                        // Add new event to calendar
                        addEventToCalendar(event: event)
                    }
                    else {
                        events2[self.tag] = event
                        editCalendarEvent(event: event)
                    }
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(events2) {
                        UserDefaults.standard.set(encoded, forKey: "events")
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Reference: https://medium.com/swift-productions/add-an-event-to-the-calendar-xcode-12-swift-5-3-35b8bf149859
    // Add an event to system calendar
    func addEventToCalendar(event: Event){
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {

              let cal_event:EKEvent = EKEvent(eventStore: eventStore)
              let date = getDateFromEvent(event: event)
              
              cal_event.title = event.title
              cal_event.startDate = date
              cal_event.endDate = date
              cal_event.notes = event.description
              cal_event.calendar = eventStore.defaultCalendarForNewEvents
              do {
                  try eventStore.save(cal_event, span: .thisEvent)
                  
                  // Store events_id for future edit/delete
                  if var events_id = UserDefaults.standard.object(forKey: "events_id") as? [String]{
                      events_id.append(cal_event.eventIdentifier)
                      print("Event_id in add: \(String(describing: cal_event.eventIdentifier))")
                      UserDefaults.standard.set(events_id, forKey: "events_id")
                  }else{
                      let array:[String] = [cal_event.eventIdentifier]
                      UserDefaults.standard.set(array, forKey: "events_id")
                      print("Set new events_id")
                  }
                  
              } catch let error as NSError {
                  print("failed to save event with error : \(error)")
              }
              print("Saved Event")
          }
          else{
          
              print("failed to save event with error : \(error!) or access not granted")
          }
        }
    }
    
    
    func editCalendarEvent(event: Event){
        if let events_id = UserDefaults.standard.object(forKey: "events_id") as? [String]{
            
            let eventStore : EKEventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
              
              if (granted) && (error == nil) {
                  let event_id = events_id[self.tag]
                  print("Event_id in edit: \(event_id)")
                  if let cal_event = eventStore.event(withIdentifier: event_id){
                      let date = getDateFromEvent(event: event)
                      
                      cal_event.title = event.title
                      cal_event.startDate = date
                      cal_event.endDate = date
                      cal_event.notes = event.description
                      do {
                          try eventStore.save(cal_event, span: .thisEvent, commit: true)
                      } catch let error as NSError {
                          print("failed to save changed event with error : \(error)")
                      }
                  }else{
                      print("Cannot find event: \(event_id)")
                  }
              }else{
                  print("failed to save event with error : \(error!) or access not granted")
              }
                
            }
        }else{
            print("In edit: no events_id")
        }
    }

}
