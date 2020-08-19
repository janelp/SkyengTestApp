//
//  MeaningCell.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import UIKit
import AlamofireImage

struct MeaningCellModel {
    var translation: String?
    var transcription: String?
    var note: String?
    var speechCode: String?
    var imageUrl: String?
    
    init(meaning: MeaningResponse) {
        self.translation = meaning.translation?.text
        self.transcription = meaning.transcription
        self.note = meaning.translation?.note
        self.speechCode = meaning.partOfSpeechCode?.localizedValue
        self.imageUrl = meaning.previewUrl
    }
}

class MeaningCell: UITableViewCell {
    @IBOutlet private weak var translationLabel: UILabel!
    @IBOutlet private weak var transcriptionLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var partOfSpeechCodeLabel: UILabel!
    @IBOutlet private weak var meaningImageView: UIImageView!
    @IBOutlet private weak var soundButton: UIButton!

    var soundButtonClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func applyModel(_ model: MeaningCellModel) {
        self.translationLabel.text = model.translation
        self.transcriptionLabel.text = model.transcription
        self.noteLabel.text = model.note
        self.partOfSpeechCodeLabel.text = model.speechCode
        if let imageUrl = model.imageUrl, let url = URL(string: "https:" + imageUrl) {
            let placeholderImage = UIImage(named: "placeholder")!
            meaningImageView.af.setImage(withURL: url, placeholderImage: placeholderImage)
        }
    }
    
    @IBAction private func soundButtonClicked(_ sender: UIButton) {
        self.soundButtonClicked?()
    }
}
