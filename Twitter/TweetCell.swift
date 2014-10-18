//
//  TweetCell.swift
//  Twitter
//
//  Created by Ziyang Tan on 10/7/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func cellSelected(screenName: String)
}

class TweetCell: UITableViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        profileImageView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handleLongPressGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Ended {
            println("long press")
            delegate?.cellSelected(self.screenLabel.text!)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
