//
//  ViewController.swift
//  ToDue
//
//  Created by Yiding Tao on 11/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    //@Huilin
    @IBOutlet weak var table: UITableView!
    var models = [MyReminder]()
    
    
//    @IBAction func addReminders(_ sender: Any) {
//    }
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    var theData:[event] = []
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        setupCollectionView()
//
//        DispatchQueue.global(qos: .userInitiated).async {
//
//            self.fetchDataForcollectionView()
//
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }

//    }

    //functions
    
    //setupCollectionView
//    func setupCollectionView() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//
//    }
//
//    //fetchDataForcollectionView
//    func fetchDataForcollectionView(){
//        // Currently only for demo, no database query
//        let demoEvent = event(year: 2022, month: 11, day: 11, weekDay: "Friday", title: "CSE599 HW3")
//        theData.append(demoEvent)
//    }
    
    
//    func collectionView(_ collectionView: UIcollectionView, didSelectRowAt indexPath: IndexPath) {
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

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return theData.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionViewCell
//        cell.title.text = theData[indexPath.row].title
//        return cell
//    }

}

//@Huilin
struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}
