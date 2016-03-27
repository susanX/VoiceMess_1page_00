//
//  RecordSoundsViewController.swift
//  VoiceMess_2March
//
//  Created by s gooding on 02/03/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio! //model

    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var playRecording: UIButton!
    @IBOutlet weak var tAdd: UITextField!
    @IBOutlet weak var fetchView: UITextView!
    @IBOutlet weak var fetchtext: UIButton!

    var db:CKDatabase!
    
    var itemRecord:[CKRecord] = []
    
    override func viewDidLoad() {
               super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordAudio.hidden = false
        recordingLabel.hidden = true
        playRecording.hidden = true
        stopRecording.hidden = true
        tAdd.hidden = false
        fetchView.hidden = true
        fetchtext.hidden = true
        

        
db = CKContainer.defaultContainer().publicCloudDatabase
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    override func viewWillAppear(animated: Bool) {
        // hide stop button
        stopRecording.hidden = true
        recordAudio.enabled = true
        playRecording.hidden = true
        recordingLabel.enabled = true
        fetchtext.hidden = true
            }

    
    @IBAction func RecordAudio(sender: AnyObject) {
        recordingLabel.hidden = false
                stopRecording.hidden = false
        recordAudio.enabled = false
        playRecording.hidden = true
        
        // Record use model recordedAudio.filePathUrl
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
       let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
//        print("filePath\(filePath)")
//        
//        let audioURL = NSURL(fileURLWithPath:recordingName)
//        
//        print("....filePath......\(filePath)")
//     
//        print("....unwrapped filePath_______\(filePath!)")
//       
        
       //submitRecording()
         //new
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch _ {
        }
        do {
            // use speaker instead
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch _ {
        }
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [String: AnyObject]())
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool){
        if(flag){
            
              // save the recorded audio. Use initializer to init the instance.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, text: recorder.url.lastPathComponent!)
            // move to the 2nd scene: perform segue
            //self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordAudio.enabled = true
            stopRecording.hidden = true

        }
        print("MODEL recordedAudio_________________________________________")
        
        print("recordedAudio.filePathUrl:\(recordedAudio.filePathUrl)")
        print("recordedAudio.text:\(recordedAudio.text)")
        print("_________________________________________")
    }

   
    
    @IBAction func StopRecording(sender: AnyObject) {
        audioRecorder.stop()
        recordingLabel.hidden = true
        recordAudio.hidden = true
        playRecording.hidden = false
        fetchtext.hidden = false
        fetchView.hidden = false

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            
            
        } catch _ {
        }
    }
    
    func setupPlayer(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            
            
        } catch _ {
        }
        audioPlayer = try? AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        audioPlayer.enableRate = true
    }
    
    var audioPlayer:AVAudioPlayer!
  
    
    @IBAction func playNormal(_: AnyObject) {
        setupPlayer()
        audioPlayer.play()
    }
    
    @IBAction func sendBtn(sender: AnyObject) {
        let uuid:String = NSUUID().UUIDString
        
        tAdd.text="ok"
        audioPlayer.enableRate = false
        
        let itemRecordID = CKRecordID(recordName: uuid)
        let itemRecord: CKRecord = CKRecord(recordType: "Messages", recordID:itemRecordID)
        itemRecord["usermsg"] = "sgooding"
        
        let audioURL = recordedAudio.filePathUrl
        let file:CKAsset? = CKAsset(fileURL: audioURL)//fileURL is type NSURL
        itemRecord.setValue(file, forKey: "AudioFile")
         itemRecord.setValue(tAdd.text, forKey: "text")
        
        db.saveRecord(itemRecord) {(record:CKRecord?, error:NSError?) -> Void in
            if error == nil {
                print("audio saved!")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tAdd.text = "gone to CloudKit"
            })
         }
    }
        
//
    }
    
    @IBAction func fetchButton(sender: AnyObject) {
        loadCloudData()
    }
   
    func loadCloudData(){
        
        
      // publicDatabase.fetchRecordWithID(itemRecordID)
                let predicate:NSPredicate = NSPredicate(value: true)
        fetchView.text = "(fetching cloud data...)"
        let query:CKQuery = CKQuery(recordType: "Messages", predicate: predicate)
        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil {
                return
            }
            self.itemRecord.removeAll()
            self.itemRecord = records!
            
            var aList:[String] = []
            for var i:Int = 0; i < records?.count; i++ {
                let record:CKRecord = records![i]
                aList.append(record.objectForKey("text") as! String)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.fetchView.text = aList.joinWithSeparator("\n")
            })
        }
    }
    
    //****************new
    
//    func downloadAudio() {
//    
//        
//      let asset = itemRecord["AudioFile"] as! CKAsset
//        contentsOfFile: asset.fileURL.absoluteString
//    }
//    
//        
    
        
        
        
        db.fetchRecordWithID(id) { (results, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if error != nil {
                    
                    print(" Error Fetching Record  " + error!.localizedDescription)
                } else {
                    if results != nil {
                        print("pulled record")
                        
                        let record = results!
                        let audioPlayer  = record.objectForKey("AudioFile") as! CKAsset
                        
                        //self.audioPlayer.fileURL
                        
                       // print("     After Download: \(audioPlayer.filePathUrl!)")
                        
                        //self.audioPlayer.filePathUrl!
                        self.audioPlayer.play()
                        
                    } else {
                        print("results Empty")
                    }
                }
            }
        }
    }
    
    
    //********************
    
    
}
//    class func getDocumentsDirectory() -> NSString {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
//        let documentsDirectory = paths[0]
//        print(documentsDirectory)
//        return documentsDirectory
//        
//    }
//    
//    class func getMp3URL() -> NSURL {
//        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("meet.m3a")
//        let audioURL = NSURL(fileURLWithPath: audioFilename)
//        print(audioURL)
//        return audioURL
//    }
    



