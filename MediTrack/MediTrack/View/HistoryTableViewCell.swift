//
//  HistoryTableViewCell.swift
//  MediTrack
//
//  Created by Manjunath on 27/07/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scroreLabel: UILabel!
    @IBOutlet weak var morningView: UIView!
    @IBOutlet weak var morningTimeLabel: UILabel!
    @IBOutlet weak var afternoonView: UIView!
    @IBOutlet weak var afternoonTimeLabel: UILabel!
    @IBOutlet weak var eveningView: UIView!
    @IBOutlet weak var eveningTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.layer.borderColor = UIColor.systemGray4.cgColor
        backGroundView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
