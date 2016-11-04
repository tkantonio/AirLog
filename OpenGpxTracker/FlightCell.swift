//
//  flightCell.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 02/09/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit

class FlightCell: UITableViewCell {

    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(mainText: String, subtext: String){
        mainLbl.text = mainText
        subLbl.text = subtext
    }

}
