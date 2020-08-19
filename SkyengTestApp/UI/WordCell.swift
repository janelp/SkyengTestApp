//
//  WordCell.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import UIKit

struct WordCellModel {
    var attributedText: NSAttributedString?
    
    init(text: String?, searchString: String?) {
        guard let text = text, let searchString = searchString else {
            return
        }
        let fullNameAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])

        let ranges = (text as NSString).ranges(of: searchString, options: .caseInsensitive)
        for range in ranges {
            fullNameAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.squash, range: range)
        }
        attributedText = NSAttributedString(attributedString: fullNameAttributedString)
    }
}

class WordCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func applyModel(_ model: WordCellModel) {
        self.titleLabel.attributedText = model.attributedText
    }
}
