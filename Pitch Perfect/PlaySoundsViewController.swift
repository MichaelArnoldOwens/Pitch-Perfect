//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Owens on 4/29/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //declaring global variables, audio player, audio recorder, audio engine
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //instantiating audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true //allowing rate changes to the audio
        
        //instantiating the audio engine
        audioEngine = AVAudioEngine()
        
        //defining the audio file with receivedAudio from previous view
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
//###########################
//PLAYBACK_FUNCTIONS_BEGIN
//###########################
    //changes rate of audio playback
    func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop() //stops the player
        audioEngine.stop() //stops the engine
        audioEngine.reset() //resets all the audio nodes in the engine
        
        audioPlayer.currentTime = 0.0 //sets current time in audio to the beginning
        audioPlayer.rate = rate //sets playback rate to rate
        audioPlayer.play()
        
    }
    
    //changes pitch of audio playback
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop() //stops the player
        audioEngine.stop() //stops the engine
        audioEngine.reset() //resets all the audio nodes in the engine
        
        
        // #instantiates audio player node
        // #audio nodes are used to generate audio signals, process them, and perform audio input and output
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // instantiate AVAudioUnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch //changing pitch to function parameter pitch
        audioEngine.attachNode(changePitchEffect) //attaching the changePitchEffect audio node
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil) //connect the audioPlayerNode to the changePitchEffect node
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil) //connect the changePitchEffect node to audioEngine output
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil) //schedule playing audio file
        audioEngine.startAndReturnError(nil) //start the audio engine
        
        audioPlayerNode.play()
    }
//###########################
//PLAYBACK_FUNCTIONS_END
//###########################

    
//###########################
//VARIABLE_RATE_BUTTONS_BEGIN
//###########################
    //plays slow audio
    @IBAction func playbackSlow(sender: AnyObject) {
       playAudioWithVariableRate(0.5)
    }
    
    //play fast audio
    @IBAction func playbackFast(sender: AnyObject) {
        playAudioWithVariableRate(2)
    }
    
    @IBAction func playbackNormal(sender: AnyObject) {
        playAudioWithVariableRate(1)
    }
//###########################
//VARIABLE_RATE_BUTTONS_END
//###########################
    
    
//###########################
//VARIABLE_PITCH_BUTTONS_BEGIN
//###########################
    //plays 'chipmunk' (high pitch) audio
    @IBAction func playbackChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000) //pitch is set to 1000
    }
    
    //play 'darthvader' (low pitch) audio
    @IBAction func playbackDarthvader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    //play original audio
        @IBAction func playbackStop(sender: AnyObject) {
        audioPlayer.stop() //stop playback
    }
//###########################
//VARIABLE_PITCH_BUTTONS_BEGIN
//###########################
    
}