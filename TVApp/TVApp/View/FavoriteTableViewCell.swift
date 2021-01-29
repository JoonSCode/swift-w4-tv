//
//  FavoriteTableViewCell.swift
//  TVApp
//
//  Created by 윤준수 on 2021/01/29.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.becomeFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(title: String, subTitle: String) {
        self.title.text = title
        self.subTitle.text = subTitle
    }
    


}
