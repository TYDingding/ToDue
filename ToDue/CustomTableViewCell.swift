//
//  CustomTableViewCell.swift
//  ToDue
//
//  Created by Mavis on 2022/11/13.
//

import UIKit

protocol CellDelegate: AnyObject{
    func eventCell(didTapButton button: RadioButton)
}

class CustomTableViewCell: UITableViewCell{
    
    weak var delegate: CellDelegate?

    @IBOutlet weak var radioButton: RadioButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainLabel: UILabel!
    @IBOutlet weak var timeBar: DisplayView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickRadioButton(_ sender: RadioButton) {
        delegate?.eventCell(didTapButton: sender)
    }
}
