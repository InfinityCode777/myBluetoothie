//
//  DeviceTableViewCell.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/2/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
