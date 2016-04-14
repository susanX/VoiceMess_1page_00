//
//  RecordSoundsViewController.swift
//  VoiceMess_2March
//
//  Created by s gooding on 02/03/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//  note update number in uniqueReference before running

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
    @IBOutlet weak var fetchtext: UIButton!
    @IBOutlet weak var fetchView: UITextView!
    @IBOutlet weak var tAdd: UITextField!
    
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
        //        let audioURL = NSURL(fileURLWithPath:recordingName)
        //        print("....filePath......\(filePath)")
        //        print("....unwrapped filePath_______\(filePath!)")
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
    
    @IBAction func playNormal(sender: AnyObject) {
        setupPlayer()
        audioPlayer.play()
    }
    
    @IBAction func FetchButton(sender: AnyObject) {
        //loadCloudData()
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
    
    
    @IBAction func sendButton(sender: AnyObject) {
        if tAdd.text == "" || tAdd.text == nil {
            return
        }
        fetchtext.hidden = false
        
        
        
        
        // let uuid:String = NSUUID().UUIDString
        
        //tAdd.text="Sending"
        // audioPlayer.enableRate = false
        
        //let itemRecordID =         CKRecordID(recordName: uuid)
        //let itemRecord =         CKRecord["title"] = "Msg"
        //let audioRecord:CKRecord = CKRecord( recordType: "Photo", recordID: photoRecordID)
        
        let uniqueReference = "sg63"
        
//        let uniqueReference = NSUUID().UUIDString
       let uniqueRecordID = CKRecordID(recordName: uniqueReference)
        
        let itemRecord: CKRecord = CKRecord(recordType: "Messages", recordID:uniqueRecordID)//, recordID:itemRecordID)
        //let itemRecord["usermsg"] = "sg"
        let audioURL = recordedAudio.filePathUrl
        let file:CKAsset? =        CKAsset(fileURL: audioURL)//fileURL is type NSURL
        //let itemRecordID =        CKRecordID(recordName: uuid)//fileURL is type NSURL
//        itemRecord.setValue(file,         forKey: "AudioFile")//@@
//        itemRecord.setValue(tAdd.text,    forKey: "atext") //displ
//        
        itemRecord["AudioFile"] = file
        itemRecord["atext"] = tAdd.text
        
        
//        itemRecord.setValue(file,         forKey: "AudioFile")//@@
//        itemRecord.setValue(tAdd.text,    forKey: "atext") //displays by this field ascending
//        // itemRecord.setValue(itemRecordID, forkey: "recordName")
        // itemRecord.setValue(itemRecordID, forKey: "Record Name")
        
        db.saveRecord(itemRecord) {(record:CKRecord?, error:NSError?) -> Void in
            if error == nil {
                print("audio saved!")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tAdd.text = "Message sent"
                })
            }
        }
    }
    
    
    
/////////////
    
    @IBAction func playAsset(sender: AnyObject) {
        // Fetch the Sound data set
        
       
        
        let predicate = NSPredicate(value: true)
        
        let myQuery = CKQuery(recordType: "Messages", predicate: predicate)
        //db.fetchRecordWithID("sg59")
        //db.fetchRecordWithID(sg59)
        //REF TO DB, call PERFORM QUERY, PASS IN QUERY OBJECT, zone (caped at 200 records)
        
        db.performQuery(myQuery, inZoneWithID: nil){
            records, error in
            if error != nil{
                print(error!.localizedDescription)
            }else {

            if let asset = NSDataAsset(name:"AudioFile") {
            print("I have the audiofile")
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound
                try self.audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                // Play the above sound file
                self.audioPlayer.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
        }
    }
    
//////
    
    
    
    
    
    
    
    
    
    @IBAction func fetchAsset(sender: AnyObject) {
        fetchMyAsset()
        
    }
    func fetchMyAsset(){
        /////FETCH///////////////
               
       let predicate = NSPredicate(value: true)
        
        let myQuery = CKQuery(recordType: "Messages", predicate: predicate)
        
        //REF TO DB, call PERFORM QUERY, PASS IN QUERY OBJECT, zone (caped at 200 records)
        
        db.performQuery(myQuery, inZoneWithID: nil) {
            
            //2 objects in the completionhandler will execute
            records, error in
            if error != nil{
                print(error!.localizedDescription)
            }else {
                
                
                
                for element in records! {
                    if let asset = NSDataAsset(name: "Messages") {
                        print("asset")
                        
                        let data = asset.data
                        //print(data)
                        self.audioPlayer = try! AVAudioPlayer(data:data)
                        self.audioPlayer.play()
                    }
                    
                    
                    
                    //self.itemRecord.append(element as CKRecord)
                    self.itemRecord.append(element as CKRecord)
                    
                    print(element)
                    //print(CKAsset(fileURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("temporary", ofType: "wav")!)))
                    
                }
                
                
                
                
                
                
                
                var aList:[String]=[]
                var i = 0
                for i=0; i < records?.count; i++ {
                    let results:CKRecord = records![i]
                    aList.append(results.objectForKey("atext") as! String)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.fetchView.text = aList.joinWithSeparator("\n")})
                
            }
            
            
            
            
            
            //var newpath = CKAsset.fileURL             //dispatch_async(dispatch_get_main_queue()) {
            //self.
            
            
            
            
            
            
            
            
            
            
            // delegate?.errorUpdating(error)
            
            //return
            
            // print("results 2")
            
            
            
            
        }
        
        
        
        //[http://stackoverflow.com/questions/32878358/play-video-downloaded-through-cloudkit-as-ckasset-ios]
        
        //        func downloadVideo(id: CKRecordID) {
        //
        //            db.fetchRecordWithID(id) { (results, error) -> Void in
        //
        //                dispatch_async(dispatch_get_main_queue()) { () -> Void in
        //                    if error != nil {
        //
        //                        print(" Error Fetching Record  " + error!.localizedDescription)
        //                    } else {
        //                        if results != nil {
        //                            print("pulled record")
        //
        //                            let record = results as CKRecord!
        //                            let audioFile = record.objectForKey("AudioFile") as! CKAsset
        //
        //                            self.audioPlayer = audioFile.fileURL as NSURL!
        //                            let audioData = NSData(contentsOfURL: self.filePathUrl!)
        //                            //---------------------------------------------------------------------------
        //
        //                            func setupPlayer(){
        //                                let audioSession = AVAudioSession.sharedInstance()
        //                                do {
        //                                    try audioSession.setActive(false)
        //                                } catch _ {
        //                                }
        //                                audioPlayer = try? AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        //                                audioPlayer.enableRate = true
        //                            }
        //
        //                            var audioPlayer:AVAudioPlayer!
        //
        //                            @IBAction func playNormal(sender: AnyObject) {
        //                                setupPlayer()
        //                                audioPlayer.play()
        //                            }
        //
        //
        //                            ///--------------------------------------------------------------------------
        //                            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        //  let destinationPath = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("filename.wav", isDirectory: false) //This is where I messed up.
        //                            -----------------------------------------------------------------------------------------------------
        //                            NSFileManager.defaultManager().createFileAtPath(destinationPath.path!, contents:audioData, attributes:nil)
        //
        //                            self.filePathUrl = destinationPath
        //
        //                            self.audioAsset = AVURLAsset(URL: self.newPlayPath!)
        //
        //                            self.audioPlayer.play()
        //                        } else {
        //                            print("results Empty")
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
        func loadCloudData(){
            //PREDICATE FOR TEXT ONLY
            // let predicate:NSPredicate = NSPredicate(value: true)
            let predicate:NSPredicate = NSPredicate(format: "AudioFile", argumentArray:[true])
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
                    aList.append(record.objectForKey("path") as! String)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.fetchView.text = aList.joinWithSeparator("\n")
                })
            }
        }
    }
    //
    //    func loadCloudData(){
    //
    //
    //      // publicDatabase.fetchRecordWithID(itemRecordID)
    //        let predicate:NSPredicate = NSPredicate(value: true)
    //        fetchView.text = "(fetching cloud data...)"
    //
    //        let query:CKQuery = CKQuery(recordType: "Messages", predicate: predicate)
    //
    //        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
    //            if error != nil || records == nil {
    //                return
    //            }
    //            self.itemRecord.removeAll()
    //            self.itemRecord = records!
    //
    //            var aList:[String] = []
    //            for var i:Int = 0; i < records?.count; i++ {
    //                let record:CKRecord = records![i]
    //                aList.append(record.objectForKey("text") as! String)
    //            }
    //            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
    //                self.fetchView.text = aList.joinWithSeparator("\n")
    //            })
    //        }
    //    }
    
    //****************new
    
    //    func downloadAudio() {
    //
    //
    //      let asset = itemRecord["AudioFile"] as! CKAsset
    //        contentsOfFile: asset.fileURL.absoluteString
    //    }
    //
    //
    
    
    
    
    //        db.fetchRecordWithID(id) { (results, error) -> Void in
    //
    //            dispatch_async(dispatch_get_main_queue()) { () -> Void in
    //                if error != nil {
    //
    //                    print(" Error Fetching Record  " + error!.localizedDescription)
    //                } else {
    //                    if results != nil {
    //                        print("pulled record")
    //                        
    //                        let record = results!
    //                        let audioPlayer  = record.objectForKey("AudioFile") as! CKAsset
    //                        
    //                        //self.audioPlayer.fileURL
    //                        
    //                       // print("     After Download: \(audioPlayer.filePathUrl!)")
    //                        
    //                        //self.audioPlayer.filePathUrl!
    //                        self.audioPlayer.play()
    //                        
    //                    } else {
    //                        print("results Empty")
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    //////\\\\\\\\\\\\\\\\\\\\\\\\
//    let operation = CKFetchRecordsOperation(recordIDs: [myRecordID]){
//    operation.desiredKeys = ["Messages"]
//    operation.perRecordProgressBlock = {
//    record,progress in
//    
//    dispatch_async(dispatch_get_main_queue(), {
//    self.progressIndicatorView.progress = CGFloat(progress)
//    })
//    
//    }
//    
//    operation.perRecordCompletionBlock = {
//    record,recordID,error in
//    if let _ = record{
//    let asset = record!.valueForKey("AudioFile") as? CKAsset
//    
//    if let _ = asset{
//    
//    let url = asset!.fileURL
//    let imageData = NSData(contentsOfFile: url.path!)!
//    dispatch_async(dispatch_get_main_queue(), {
//    
//    self.image = UIImage(data: imageData)
//    self.progressIndicatorView.reveal()
//    
//    })
//    completion(asset!)
//    }
//    }
//    
//    }
//        CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
//    }
//        
//    ///\\\\\\\\let operation = CKFetchRecordsOperation(recordIDs: [myRecordID])
//    //let publicDb = CKContainer.defaultContainer().publicCloudDatabase
//    let configRecordId = CKRecordID(recordName: "e783f542-ec0f-46j4-9e99-b3e3ez505adf")
//    
//    db.fetchRecordWithID(configRecordId) { (record, error) -> Void in
//    dispatch_async(dispatch_get_main_queue()) {
//    guard let photoRecord = record else { return }
//    guard let asset = photoRecord["image"] as? CKAsset else { return }
//    
//    guard let photo = NSData(contentsOfURL: asset.fileURL) else { return }
//    
//    let image = UIImage(data: photo)!
//    
//    cell.cardImageView.image = image
//    }
//    }
//}//http://stackoverflow.com/questions/35448287/fetching-ckasset-image-from-cloudkit-is-very-slow?rq=1
}