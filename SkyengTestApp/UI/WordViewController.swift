//
//  WordViewController.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import UIKit
import AVFoundation

class WordViewController: UITableViewController {
    
    var word: WordResponse!
    
    private var player : AVAudioPlayer?
    private var fileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = word.text
    }
    
    // MARK: - Private
    
    private func playMeaningSound(_ meaning: MeaningResponse) {
        if let urlstring = meaning.soundUrl, let url = URL(string: "https:" + urlstring) {
            downloadFileFromURL(url)
        }
    }
    
    private func downloadFileFromURL(_ url: URL){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }

                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentsPath.appendingPathComponent("sound.mp3")
                self.fileUrl = destinationURL
                // delete original copy
                try? FileManager.default.removeItem(at: destinationURL)
                // copy from temp to Document
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationURL)
                    self.play(url: destinationURL)
                } catch let error {
                    print("Copy Error: \(error.localizedDescription)")
                }

            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()

    }
    
    func play(url: URL) {
        print("playing \(url)")
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
        }
        catch {
            log.error(error.localizedDescription)
        }

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return word.meanings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeaningCell", for: indexPath) as! MeaningCell
        let meaning = word.meanings[indexPath.row]
        cell.applyModel(MeaningCellModel(meaning: meaning))
        cell.soundButtonClicked = {
            self.playMeaningSound(meaning)
        }
        return cell
    }
}

extension WordViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        log.error(error?.localizedDescription)
        guard let url =  fileUrl else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let url =  fileUrl else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }
    
}
