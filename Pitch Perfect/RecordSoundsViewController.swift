//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Owens on 4/5/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//
//TODO: showcases at least one additional audio effect, such as echo or reverb.


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordAudio: UIButton!
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var nextPageOutlet: UIButton!
    
    //declaring global variables
    var audioRecorder:AVAudioRecorder! //audio recorder
    var recordedAudio:RecordedAudio! //recorded audio will be stored here
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //reveal status button named 'recordingInProgress'
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to Record"
        
        //hide stop button
        stopRecordAudio.hidden = true
        pauseOutlet.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Record user's voice
        recordingInProgress.hidden = false
        recordingInProgress.text = "Recording"
        
        stopRecordAudio.hidden = false
        recordButton.enabled = false
        pauseOutlet.hidden = false
        
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
            recordingInProgress.text = "Paused Recording"
        }
        else {
            self.isPaused = false
            audioRecorder.record()
            recordingInProgress.text = "Recording"
        }
        

        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //initializing recordedAudio, setting path and title
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePath: recorder.url)
            
            //move to second scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)//recordedaudio is being sent
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
        
        //hide recording in progress text label and stop button
        stopRecordAudio.hidden = true
        
        //re-enable record button
        recordButton.enabled = true

        //stop recording and deactivate the session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func startOver(sender: AnyObject) {
        //reveal text label notification "Tap to Record"
        recordingInProgress.text = "Tap to Record"
        
        //hide recording in progress text label and stop button
        stopRecordAudio.hidden = true
        
        //re-enable record button
        recordButton.enabled = true
        }
    
}

