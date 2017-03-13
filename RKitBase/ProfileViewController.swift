/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import ResearchKit
import HealthKit

class ProfileViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var welcomeNameTextField: UITextField!
    var defaults: NSUserDefaults
    
    //IF NUMBER OF SECTIONS MODIFIED IN JSON, MUST BE MODIFIED HERE AS WELL!!
    let numSections = 2
    var profileSection = [[ProfileProperty](),[ProfileProperty]()]

    
    var healthStore: HKHealthStore?
    
    // MARK: UIViewController
    required init?(coder aDecoder: NSCoder) {
        defaults = NSUserDefaults.standardUserDefaults()
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("viewdidload")
        let firstName = defaults.stringForKey(Constants.FIRST_NAME) //as! String //CAN'T BE NIL!
        let lastName = defaults.stringForKey(Constants.LAST_NAME) //as! String
        if lastName != nil && firstName != nil {
            // Ensure the table view automatically sizes its rows.
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If sections are added, switch cases must be added!
        if section < profileSection.count {
            return profileSection[section].count
        }else{
            print("Number of Sections declared exceeds the number coded for")
        }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //returns number of sections
        return numSections
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(ProfileStaticTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ProfileStaticTableViewCell else { fatalError("Unable to dequeue a ProfileStaticTableViewCell") }
        
        cell.titleLabel.text = profileSection[indexPath.section][indexPath.row].profileTitle
        cell.valueLabel.hidden = profileSection[indexPath.section][indexPath.row].hide
        
        if let tempValueLabel = defaults.stringForKey(cell.titleLabel.text!) {
            cell.valueLabel.text=tempValueLabel
        } else {
            cell.valueLabel.text = "Not Set"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 32.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //conect save button
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! DetailTableViewController
        
        let index = detailViewController.index
        let profileString = detailViewController.editProfileTextField.text
        let cell = self.tableView.cellForRowAtIndexPath(index!) as!ProfileStaticTableViewCell
        cell.valueLabel.text = NSLocalizedString(profileString!, comment: "")
        defaults.setObject(profileString, forKey: cell.titleLabel.text!)
        print(profileString)
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            
            self.tableView.reloadData()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            
            let path = tableView.indexPathForSelectedRow
            let cell = sender as? ProfileStaticTableViewCell
            let detailViewController = segue.destinationViewController as! DetailTableViewController
            let property = profileSection[path!.section][path!.row]
            
            detailViewController.index = path!
            detailViewController.profileData = cell?.valueLabel.text
            detailViewController.currentTitle = property.detailTitle
            detailViewController.pickerData = property.choices
            detailViewController.prompt = property.prompt
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
class ProfileProperty{
    var detailTitle: String
    var profileTitle: String
    var prompt: String
    var hide: Bool
    var section: String
    var choices: [String]
    init(detail: String,profile: String, promptString: String, choiceList: [String], hidden: Bool, sectionTitle: String){
        detailTitle = detail
        profileTitle = profile
        prompt = promptString
        choices = choiceList
        hide = hidden
        section = sectionTitle
    }
}
