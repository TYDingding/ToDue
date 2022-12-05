//
//  ViewController.swift
//  ToDue
//
//  Created by Yiding Tao on 11/9/22.
//

import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var showOnlyHighPriorityEvents: Bool = false;
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var togglePriorityButton: UIBarButtonItem!
    
    
    @IBAction func toggleShowPriority(_ sender: Any) {
        self.showOnlyHighPriorityEvents = !self.showOnlyHighPriorityEvents
        self.syncPriorityButton()
        self.tableView.reloadData()
        
    }
    func syncPriorityButton(){
        if(self.showOnlyHighPriorityEvents){
            self.togglePriorityButton.title = "Show all"
        }else{
            self.togglePriorityButton.title = "Show high"
        }
    }
    
    var theData:[Event] = []
    override func viewWillAppear(_ animated: Bool) {
        self.syncPriorityButton()
        if let data = UserDefaults.standard.data(forKey: "events"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Event].self, from: data) {
                self.theData = decoded
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self
        self.registerTableViewCells()
        /*
        UserDefaults.standard.removeObject(forKey: "events")
        UserDefaults.standard.removeObject(forKey: "events_id")
        */
         if UserDefaults.standard.data(forKey: "events") == nil {
            let encoder = JSONEncoder()
            UserDefaults.standard.set(try? encoder.encode(self.theData), forKey: "events")
        }
    }

    // Show detail view with empty contents
    @IBAction func addReminder(_ sender: Any) {
        self.performSegue(withIdentifier: "showEventDetail", sender: nil)
    }
    
    private func registerTableViewCells() {
        let eventCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(eventCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    // Swipe right to left to show delete option
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView.cellForRow(at: indexPath) is CustomTableViewCell {
                theData.remove(at: indexPath.row)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(theData) {
                    UserDefaults.standard.set(encoded, forKey: "events")
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                removeEventFromCalendar(indexPathRow: indexPath.row)
            }
        }
    }
    
    // Show event details page on click with selected event contents
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "showEventDetail", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell {
            let priority = theData[indexPath.row].priority
            cell.priorityLabel.text = "Priority: "+priority
            if(priority == highConst){
                cell.priorityLabel.textColor = UIColor.red
            }else if(priority == mediumConst){
                cell.priorityLabel.textColor = UIColor.orange
            }else{
                cell.priorityLabel.textColor = UIColor.green
            }
            if(priority != highConst && self.showOnlyHighPriorityEvents){
                return UITableViewCell()
            }
            cell.radioButton.isSelected = theData[indexPath.row].isComplete
            cell.titleLabel.text = theData[indexPath.row].title
            cell.locationLabel.text = theData[indexPath.row].location
            cell.timeLabel.text = setTimeLabel(event: theData[indexPath.row])
            let timeProperties = setTimeProperties(event: theData[indexPath.row])
            cell.timeRemainLabel.text = timeProperties.label
            cell.timeLabel.backgroundColor = timeProperties.color
            cell.timeBar.color = timeProperties.color
            cell.timeBar.value = timeProperties.value
            cell.delegate = self
            cell.radioButton.tag = indexPath.row
            
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let priority = theData[indexPath.row].priority
            if (priority != highConst && self.showOnlyHighPriorityEvents) {
                return 0
            }
            return self.tableView.rowHeight
        }
    
    func setTimeLabel(event: Event) -> String {
        if (event.minute < 10) {
            return "\(event.hour):0\(event.minute)"
        }
        else {
            return "\(event.hour):\(event.minute)"
        }
    }
    
    // Source from: stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
    // calculate time remain/past label
    // set color depending on left time (red: <=3d, yellow: <=1w, green: other)
    func setTimeProperties(event: Event) -> (label: String, color: UIColor, value: CGFloat) {
        var text = ""
        var color = UIColor.green
        var value = 1.0
        
        let userCalendar = Calendar.current
        let currentDate = Date()
        
        if let dueDate = getDateFromEvent(event: event) {
            let diffComponents = userCalendar.dateComponents([.month, .day, .hour, .minute], from: currentDate, to: dueDate)
            if let diffMonth = diffComponents.month, let diffDay = diffComponents.day, let diffHour = diffComponents.hour, let diffMinute = diffComponents.minute {
                value = dueDate.timeIntervalSince(currentDate)/dueDate.timeIntervalSince(event.createDate)
                if (diffMonth > 0) {
                    text += "\(diffMonth) months, \(diffDay) days left"
                }
                else if (diffDay > 0) {
                    text += "\(diffDay) days, \(diffHour) hours left"
                    if (diffDay < 7) {
                        color = UIColor.yellow
                    }
                }
                else if (diffHour > 0) {
                    text += "\(diffHour) hours, \(diffMinute) minutes left"
                    color = UIColor.red
                }
                else if (diffMinute > 0) {
                    text += "\(diffMinute) minutes left"
                    color = UIColor.red
                }
                else {
                    // current time > due time: bar value = 0, color = gray
                    // complete: label -> ""
                    // not complete: label -> "XXX overdue"
                    value = 0
                    if (!event.isComplete) {
                        color = UIColor.gray
                        if (diffMonth < 0) {
                            text += "\(-diffMonth) months, \(-diffDay) days overdue"
                        }
                        else if (diffDay < 0) {
                            text += "\(-diffDay) days, \(-diffHour) hours overdue"
                        }
                        else if (diffHour < 0) {
                            text += "\(-diffHour) hours, \(-diffMinute) minutes overdue"
                        }
                        else if (diffMinute < 0) {
                            text += "\(-diffMinute) minutes overdue"
                        }
                    }
                }
            }
        }
        return (text, color, value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CustomTableViewCell {
            let event = theData[cell.radioButton.tag]
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.titleText = event.title
                detailVC.locationText = event.location
                detailVC.descriptionText = event.description
                detailVC.dueDate = getDateFromEvent(event: event)
                detailVC.tag = cell.radioButton.tag
                detailVC.isComplete = cell.radioButton.isSelected
                detailVC.createDate = event.createDate
            }
        }
    }
    
    func removeEventFromCalendar(indexPathRow: Int){
        if var events_id = UserDefaults.standard.object(forKey: "events_id") as? [String]{
            
            let eventStore : EKEventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
              
              if (granted) && (error == nil) {
                  let event_id = events_id[indexPathRow]
                  print("Event_id in remove: \(event_id)")
                  if let cal_event = eventStore.event(withIdentifier: event_id){
                      do {
                          
                          try eventStore.remove(cal_event, span: .thisEvent, commit: true)
                          events_id.remove(at: indexPathRow)
                          UserDefaults.standard.set(events_id, forKey: "events_id")
                          
                      } catch let error as NSError {
                          print("failed to remove event with error : \(error)")
                      }
                  }else{
                      print("Cannot find event: \(event_id)")
                  }
              }else{
                  print("failed to remove event with error : \(error!) or access not granted")
              }
                
            }
        }else{
            print("In remove: no events_id")
        }
    }
}

extension ViewController: CellDelegate {
    // update current button select status
    // update the complete status in the datasource
    func eventCell(didTapButton button: RadioButton) {
        button.isSelected = !button.isSelected
        theData[button.tag].isComplete = button.isSelected
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(theData) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
}
