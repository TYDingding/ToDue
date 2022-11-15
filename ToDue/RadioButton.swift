//
//  RadioButton.swift
//  ToDue
//
//  Created by Mavis on 2022/11/13.
//

import UIKit

class RadioButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        initButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    func initButton() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.setTitle("", for: .normal)
        
        self.setImage(UIImage(named: "radio_unchecked"), for: .normal)
        self.setImage(UIImage(named: "radio_checked"), for: .highlighted)
        self.setImage(UIImage(named: "radio_checked"), for: .selected)
    }
}
