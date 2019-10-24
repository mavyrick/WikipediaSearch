//
//  ResultCell.swift
//  WikipediaSearch
//
//  Created by Josh Sorokin on 24/10/2019.
//  Copyright © 2019 Josh Sorokin. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var result: Geonames? {
        didSet {
            updateUIWeb()
        }
    }
    
    var resultStored: NSManagedObject? {
        didSet{
            updateUIStored()
        }
    }
    
    func updateUIWeb() {
        
        title.text = result?.title
        
        summary.text = result?.summary
        
        let url = URL(string: result?.thumbnailImg ?? "")
        thumbnail.kf.setImage(with: url)
        
    }
    
    func updateUIStored() {
        
        title.text = resultStored?.value(forKeyPath: "title") as? String
        
        summary.text = resultStored?.value(forKeyPath: "summary") as? String
        
        let url = URL(string: (resultStored?.value(forKeyPath: "thumbnail") as? String) ?? "")
        thumbnail.kf.setImage(with: url)
        
    }
    
}
