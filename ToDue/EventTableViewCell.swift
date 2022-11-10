//
//  EventTableViewCell.swift
//  ToDue
//
//  Created by Yiding Tao on 11/10/22.
//

import Foundation
import UIKit

class EventCollectionViewCell: UICollectionViewCell{
    // This botton is to be customized as a radio button,
    // Click -> radio become filled and this event should be
    // Removed from the screen, which means it is done.
    @IBOutlet weak var radioButton: UIButton!
    
    
    // This is the bar to show remaning time
    // We need to modify its class
    @IBOutlet weak var displayView: DisplayView!
    
    @IBOutlet weak var title: UITextField!
    
    
    
}
