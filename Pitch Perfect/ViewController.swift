//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Michael Owens on 4/5/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordAudio: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //sets background color to blue
        self.view.backgroundColor = UIColor.blueColor()

        //hide stop button
        stopRecordAudio.hidden = true

    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Record user's voice
        recordingInProgress.hidden = false
        stopRecordAudio.hidden = false
        recordButton.enabled = false
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        stopRecordAudio.hidden = true
        recordButton.enabled = true

        
    }

}

