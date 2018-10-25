//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Lorrayne on 17/07/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    struct Identifiers {
        static let stop = "Stop recording"
        static let progress = "Recording in progress"
        static let tapRecord = "Tap to Record"
        static let recordedVoice = "recordedVoice.wav"
        static let segue = "stopRecording"
    }


    // MARK: properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: outlets
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title: NSAttributedString = NSAttributedString(string: Identifiers.stop)
        stopRecordingButton.set(image: #imageLiteral(resourceName: "Stop"), attributedTitle: title, at: .bottom, width: 10.0, state: .normal)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: Identifiers.segue, sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
}

// MARK: Actions
extension RecordSoundsViewController {

    func didChangeFromState(_ isRecording: Bool = false) {
        recordingLabel.text = isRecording ? Identifiers.progress : Identifiers.tapRecord
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }

    @IBAction func stopRecording(_ sender: Any) {
        didChangeFromState(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        didChangeFromState(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = Identifiers.recordedVoice
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
}

// MARK: Navigation
extension RecordSoundsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.segue {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
