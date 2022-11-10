//
//  ViewController.swift
//  ToDue
//
//  Created by Yiding Tao on 11/9/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBAction func addReminders(_ sender: Any) {
    }
    
    var theData:[event] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTableView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.fetchDataForTableView()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    //functions
    
    //setupTableView
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    //fetchDataForTableView
    func fetchDataForTableView(){
        // Currently only for demo, no database query
        let demoEvent = event(year: 2022, month: 11, day: 11, weekDay: "Friday", title: "CSE599 HW3")
        theData.append(demoEvent)
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //do some initialization
//
//        let detailedVC = DetailedViewController()
//
//        detailedVC.imageName = theData[indexPath.row].name
//        detailedVC.image = theImageCache[indexPath.row]
//
//
//        //push nav controller
//        navigationController?.pushViewController(detailedVC, animated: true)
//
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel!.text = theData[indexPath.row].weekDay
        
        cell.detailTextLabel?.text = theData[indexPath.row].title
        
        
        return cell

        
    }

}

