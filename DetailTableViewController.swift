//
//  DetailTableViewController.swift
//  ORKSample
//
//  Created by Admin on 8/18/16.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var editProfileTextField: UITextField!
    var index:NSIndexPath?
    var profileData:String!
    var currentTitle:String!
    var editedProfile:String?
    var prompt:String!
    var textFieldType:String!
    //following are variables for the picker  
    var pickerData: [String] = []
    var itemPicker: UIPickerView! = UIPickerView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = UIColor.redColor()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(DetailTableViewController.setFirstResponder), userInfo: nil, repeats: false)
        
    }
    
    func setFirstResponder(){
        editProfileTextField.becomeFirstResponder()
    }
    
    func setPickerView(){
        self.itemPicker.delegate = self
        self.itemPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailTableViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailTableViewController.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.translucent = false

        itemPicker.backgroundColor = UIColor.whiteColor()
        editProfileTextField.inputView = itemPicker
        editProfileTextField.inputAccessoryView = toolBar
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            editProfileTextField.becomeFirstResponder()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        performSegueWithIdentifier("unwindToProfile", sender: self)

        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.clearColor() //make the background color clear
        self.tableView.separatorStyle = .None
        header.textLabel?.text = prompt
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editProfileTextField.text = pickerData[row]
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    func donePicker() {
        editProfileTextField.resignFirstResponder()
        editProfileTextField.text = pickerData[itemPicker.selectedRowInComponent(0)]
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    func cancelPicker() {
        
        editProfileTextField.resignFirstResponder()
        
    }
}
