//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Michael Owens on 4/30/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import Foundation

//class definition for Recorded Audio
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init(title: String, filePath: NSURL){
        self.title = title
        self.filePathUrl = filePath
    }
}