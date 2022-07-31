//
//  NoMedicineTakenTableViewCell.swift
//  MediTrack
//
//  Created by Manjunath on 27/07/22.
//

import UIKit

class NoMedicineTakenTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.layer.borderColor = UIColor.systemGray5.cgColor
        backGroundView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
