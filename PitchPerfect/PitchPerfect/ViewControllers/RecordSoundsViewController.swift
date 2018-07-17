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
        let title: NSAttributedString = NSAttributedString(string: "Stop recording")
        stopRecordingButton.set(image: #imageLiteral(resourceName: "Stop"), attributedTitle: title, at: .bottom, width: 10.0, state: .normal)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording was not successful")
        }
    }
}

// MARK: Actions
extension RecordSoundsViewController {
    @IBAction func stopRecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        recordingLabel.text = "Recording in progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
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
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
