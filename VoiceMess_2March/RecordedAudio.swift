//
//  RecordedAudio.swift
//  VoiceMess_2March
//
//  Created by s gooding on 02/03/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var text: String!
    var recordID: String!
    
   // var recordID: CKRecordID!
    var genre: String!
    var comments: String!
    var audio: NSURL!
    
    
    
    init(filePathUrl: NSURL,text: String){
        self.filePathUrl = filePathUrl
        self.text = text
    }
}