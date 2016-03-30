////
////  TableViewController.swift
////  VoiceMess_2March
////
////  Created by s gooding on 30/03/2016.
////  Copyright © 2016 susan.gooding. All rights reserved.
////
//
//import UIKit
//import CloudKit
//
//class TableViewController: UITableViewController {
//    
//    var db:CKDatabase!
//    //var razeware:[CKRecord] = []
//    //var itemRecord:[CKRecord] = []
//     var inRecord:[CKRecord] = []
//    var backgroundQueue:NSOperationQueue
//    
//    required init?(coder aDecoder: NSCoder) {
//        //inRecords = []
//        backgroundQueue = NSOperationQueue()
//        super.init(coder: aDecoder)
//    }
//    override func viewDidLoad() {
//        
//        
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        
//        db = CKContainer.defaultContainer().publicCloudDatabase
//
//            let predicate = NSPredicate(value: true)
//            //let predicate = NSPredicate(format: "atext CONTAINS '3:12'")
//            let query = CKQuery(recordType: "Messages", predicate: predicate)
//            
//            
//            
//            db.performQuery(query, inZoneWithID: nil) {
//                records, error in
//                if error != nil {
//                    print(error!.localizedDescription)
//                } else{
//                    for inRecords in records!{
//                        self.inRecord.append(inRecords as CKRecord)
//                    }
//                    let queue = NSOperationQueue.mainQueue()
//                    queue.addOperationWithBlock() {
//                        self.tableView.reloadData()
//                    }
//                }
//        }
//
//    }//vdl
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//   
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//       // let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CellTableViewCell
//        let ckRecord = inRecord[indexPath.row]
//        let Name = ckRecord.objectForKey("atext") as! String
//                Cell.name.text = Name
//        
//        weak var weakCell = Cell
//        backgroundQueue.addOperationWithBlock() {
//            //let image = ckRecord.objectForKey("Photo") as CKAsset!
//            if let ckAsset = audio {
//                if let url = ckAsset.fileURL {
//                    let audioData = NSData(contentsOfURL:url)
//                    let mainQueue = NSOperationQueue.mainQueue()
//                    mainQueue.addOperationWithBlock() {
//                        cell.photo.image = UIImage(data: imageData!)
//                    }
//                    
//                }
//            }
//        }
//        
//        
//        
//        return cell
//    }
//
//        
//        
//        
//        
////        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
////        let ckRecord = record[indexPath.row]
////        let atext.ckRecord.objectForKey("atext") as String
////        cell.name.text = atext
////        return cell
////    }
//   
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
