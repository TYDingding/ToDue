//
//  DetailViewController.swift
//  ToDue
//
//  Created by Mavis on 2022/11/13.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var desciptionField: UITextField!
    
    var titleText: String = ""
    var locationText: String = ""
    var descriptionText: String = ""
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
                              location: self.locationText,
                              isComplete: self.isComplete,
                              createDate: self.createDate)
            
            if let events = UserDefaults.standard.data(forKey: "events"){
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Event].self, from: events) {
                    var events2 = decoded
                    // access detail view by add button/existing cell
                    if (isNew) {
                        events2.append(event)
                    }
                    else {
                        events2[self.tag] = event
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

}
