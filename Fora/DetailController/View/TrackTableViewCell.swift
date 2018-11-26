//
//  TrackTableViewCell.swift
//  Fora
//
//  Created by Александр Сахнюков on 21/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    @IBOutlet weak var trackLable: UILabel!
    @IBOutlet weak var trackNumberLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell (track: Track) {
        guard let number = track.trackNumber else {return}
        self.trackNumberLable.text = "\(String(describing: number))"
        self.trackLable.text = track.trackName
    }
}
