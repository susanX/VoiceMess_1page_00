//
//  TableViewController.swift
//  CellButtons
//
//  Created by Jure Zove on 20/09/15.
//  Copyright © 2015 Candy Code. All rights reserved.
////http://candycode.io/how-to-properly-do-buttons-in-table-view-cells/
//
import AVFoundation
import UIKit
import CloudKit

class TableViewController: UITableViewController, ButtonCellDelegate, AVAudioRecorderDelegate {
    
    var recordedAudio:RecordedAudio! //model
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func testSound() {
     // Grab the path, make sure to add it to your project!
    let helloSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hello", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()

    // Initial setup
        do {
     try!   audioPlayer = AVAudioPlayer(contentsOfURL: helloSound, fileTypeHint: "wav")
        
        audioPlayer.prepareToPlay()
   
   // } catch _ {
    
    }
    
    // Trigger the sound effect when the player grabs the coin
  
        audioPlayer.play()
    



}
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ButtonCell
        testSound()
        cell.rowLabel.text = "\(indexPath.row)"
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        //var audioPath = NSString(string: NSBundle.mainBundle().pathForResource(currentItem.hello, ofType: "mp3"))

        return cell
    }
        // MARK: - ButtonCellDelegate
    func setupPlayer(){
       let audioSession = AVAudioSession.sharedInstance()
       do {
       try audioSession.setActive(false)
       } catch _ {
       }
       //audioPlayer = try? AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)//??????????
       //audioPlayer.enableRate = true
    }
    
    
    func cellTapped(cell: ButtonCell) {
       
        setupPlayer()
        //audioPlayer.play()
         testSound()
        //self.showAlertForRow(tableView.indexPathForCell(cell)!.row)
    }
    
    // MARK: - Extracted method
    
//    func showAlertForRow(row: Int) {
//        let alert = UIAlertController(
//            title: "BEHOLD",
//            message: "Cell at row \(row) was tapped!",
//            preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Default, handler: { (test) -> Void in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }))
//        
//        self.presentViewController(
//            alert,
//            animated: true,
//            completion: nil)
//    }
}
