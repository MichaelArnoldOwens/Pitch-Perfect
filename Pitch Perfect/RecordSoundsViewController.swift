//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Owens on 4/5/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordAudio: UIButton!
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var nextPageOutlet: UIButton!
    
    //declaring global variables
    var audioRecorder:AVAudioRecorder! //audio recorder
    var recordedAudio:RecordedAudio! //recorded audio will be stored here
    var isPaused = false
    //TODO: showcases at least one additional audio effect, such as echo or reverb.



    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //hide stop button
        stopRecordAudio.hidden = true
        pauseOutlet.hidden = true
        nextPageOutlet.hidden = true

    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Record user's voice
        tapToRecordLabel.hidden = true
        recordingInProgress.hidden = false
        stopRecordAudio.hidden = false
        recordButton.enabled = false
        pauseOutlet.hidden = false
        nextPageOutlet.hidden = true
        
        //setting the path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //setup file name and path
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //initialize, prepare recorder and record
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //pause and resume recording audio
    @IBAction func pauseRecordAudio(sender: AnyObject) {
        if(self.isPaused == false){
            audioRecorder.pause()
            self.isPaused = true
        }
        else {
            self.isPaused = false
            audioRecorder.record()
        }
        

        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //initializing recordedAudio, setting path and title
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePath: recorder.url)
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        } else {
            println("recording unsuccessful")
            recordButton.enabled = true
            stopRecordAudio.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if user taps on stop button
        if(segue.identifier == "stopRecording"){
            //send data to recievedAudio in next view controller
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        //reveal text label notification "Tap to Record"
        tapToRecordLabel.hidden = false
        nextPageOutlet.hidden = false
        
        //hide recording in progress text label and stop button
        recordingInProgress.hidden = true
        stopRecordAudio.hidden = true
        
        //re-enable record button
        recordButton.enabled = true

        //stop recording and deactivate the session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

    //button to move to the next view and also sends audio data
    @IBAction func nextPageButton(sender: AnyObject) {
        //move to second scene aka perform segue
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)//recordedaudio is being sent
    }
}

