/*

 */

import UIKit
import ResearchKit
import HealthKit

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties
    


    @IBOutlet weak var monthSwitch: UISwitch!
    @IBOutlet weak var mailView: UITextView!
    @IBOutlet weak var linkView: UITextView!
    @IBOutlet weak var notificationPicker: SettingsPickerTableViewCell!
    @IBOutlet weak var notificationTime: SettingsTimeTableViewCell!
    
    //picker options
    var pickerTitles: [String] = [Constants.Settings.MUTE_OFF,
                                  Constants.Settings.MUTE_3_DAYS,
                                  Constants.Settings.MUTE_1_WEEK,
                                  Constants.Settings.MUTE_1_MONTH]
    
    var pickerValues: [String:Int] = [Constants.Settings.MUTE_OFF : 0,
                                      Constants.Settings.MUTE_3_DAYS : 3,
                                      Constants.Settings.MUTE_1_WEEK : 7,
                                      Constants.Settings.MUTE_1_MONTH : 30 ]
    
    //Variables for settings
    let numSettings = 7
    var textField: UITextField = UITextField()


    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        let image = Constants.Images.BACKGROUND
        nav?.setBackgroundImage(image, forBarMetrics: .Default)
        nav?.tintColor = UIColor.whiteColor()
        nav?.translucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10)
        tableView.backgroundColor = Constants.Colors.OFF_WHITE
        
        //nsuserdefaults
        monthSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(Constants.Settings.GET_MONTHLY_REMINDER)
        notificationPicker.textField.text = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Settings.MUTE_DAILY_REMINDER_DURATION) as! String
        notificationTime.textField.text = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Settings.DAILY_NOTIFICATION_TIME) as! String

    }
        override func viewDidLoad() {
        
        super.viewDidLoad()

        // Ensure the table view automatically sizes its rows.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if (tableView.contentSize.height < tableView.frame.size.height) {
            tableView.scrollEnabled = false;
        }
        else {
            tableView.scrollEnabled = true;
        }
       //add a contact url to settings page
        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(16.0) ]
        var attributedString = NSMutableAttributedString(string: Constants.Settings.URL_STRING, attributes:myAttribute )
        attributedString.addAttribute(NSLinkAttributeName, value: Constants.Settings.URL, range: NSRange(location: 0, length: attributedString.length))
        linkView.attributedText = attributedString
        
        //add a contact email to settings page
        attributedString = NSMutableAttributedString(string: Constants.Settings.EMAIL_STRING, attributes:myAttribute )
        attributedString.addAttribute(NSLinkAttributeName, value: Constants.Settings.EMAIL, range: NSRange(location: 0, length: attributedString.length))
        mailView.attributedText = attributedString
        
        self.hideKeyboardWhenTappedAround()
        tableView.tableFooterView = UIView()

    }
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numSettings
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //returns number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
       
    // MARK: Convenience
    @IBAction func textFieldEditing(sender: UITextField) {
        textField = sender
        let indexpath = self.tableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)
        print(String(indexpath!.row))
        setDatePicker(sender)
    }
    @IBAction func textFieldPicker(sender: UITextField) {
        textField = sender
        let indexpath = self.tableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)
        print(String(indexpath!.row))
        setPickerView(sender)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let pickerDate = dateFormatter.stringFromDate(sender.date)
        if !pickerDate.isEmpty {
            NSUserDefaults.standardUserDefaults().setObject(pickerDate, forKey: Constants.Settings.DAILY_NOTIFICATION_TIME)
        }
    }
    func donePicker() {
        let pickerValue = NSUserDefaults.standardUserDefaults().stringForKey(Constants.Settings.MUTE_DAILY_REMINDER_DURATION) //as! String //CANT BE NIL
        let dateString = NSUserDefaults.standardUserDefaults().stringForKey(Constants.Settings.DAILY_NOTIFICATION_TIME) //as! String
        notificationPicker.textField.text = pickerValue!
        notificationTime.textField.text = dateString!

        updateNotifications(pickerValues[pickerValue!]!, date: dateString!)
        textField.resignFirstResponder()
    }
    
    func updateNotifications(daysMuted: Int, date: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(daysMuted, forKey: Constants.DAYS_TO_MUTE_DAILY_NOTIFICATION)
        LocalNotification.deleteNotification(Constants.PAIN_LOCATION_SURVEY)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [.Hour, .Minute]
        let pickerTime = dateFormatter.dateFromString(date)
        let components = calendar.components(unitFlags, fromDate: pickerTime!)
        defaults.setInteger(components.hour, forKey: Constants.HOUR)
        defaults.setInteger(components.minute, forKey: Constants.MINUTE)
        LocalNotification.registerDailyNotification(daysMuted)
    }
    
    func cancelPicker() {
        
        textField.resignFirstResponder()
        
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cancelPicker))
        view.addGestureRecognizer(tap)
    }
    func setDatePicker(sender: UITextField){
       // print("date picker clicked!!")
        let toolBar = createToolBar()
        //declare a datepicker with colors
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "hh:mm p"
        //initiliaze time from the textfield
        print(notificationTime.textField.text!)
        datePickerView.date = dateFormatter.dateFromString(notificationTime.textField.text!)!
        datePickerView.backgroundColor = UIColor.whiteColor()
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    func setPickerView(sender: UITextField){
        
        let toolBar = createToolBar()

        //create a UIPickerView
        let itemPicker: UIPickerView! = UIPickerView()
        itemPicker.delegate = self
        itemPicker.dataSource = self
        
        //NOTE: IF CRASHES, THEN UNCOMMENT THE FOLLOWING CODE
//        //set the picker to the existing value in the textfield
//        var defaultIndex = pickerTitles.indexOf(sender.text!)
//        if defaultIndex == nil {
//            defaultIndex = 0
//        }
        //itemPicker.selectRow(defaultIndex!, inComponent: 0, animated: false)
        
        itemPicker.backgroundColor = UIColor.whiteColor()
        sender.inputView = itemPicker
        sender.inputAccessoryView = toolBar
    }
    func createToolBar() -> UIToolbar{
        //create the toolbar above the picker/date
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        //add "done" and "cancel" buttons to the toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailTableViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailTableViewController.cancelPicker))
        
        //format toolbar colors
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.barTintColor = Constants.Colors.BLUE
        toolBar.translucent = false
        return toolBar
    }
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTitles.count
    }
    
    @IBAction func monthSwitchChanged(sender: UISwitch) {
        if sender.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.Settings.GET_MONTHLY_REMINDER)
            LocalNotification.registerMonthlyNotification()
        } else {
            LocalNotification.deleteNotification(Constants.PAIN_LOCATION_SURVEY)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: Constants.Settings.GET_MONTHLY_REMINDER)
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitles[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !pickerTitles[row].isEmpty {
            NSUserDefaults.standardUserDefaults().setObject(pickerTitles[row], forKey: Constants.Settings.MUTE_DAILY_REMINDER_DURATION)
        }
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    @IBAction func viewConsent(sender: UIButton) {
        let tempPath = NSTemporaryDirectory() as NSString
        let filePath = tempPath.stringByAppendingPathComponent("ConsentDocument.pdf")
        let webView = UIWebView()
        if let fileData = NSData(contentsOfFile: filePath){
            print("attaching consent pdf")
            webView.loadData(fileData, MIMEType: "application/pdf", textEncodingName: "", baseURL: NSURL())
        }
        // Create web view controller.
        let webViewController = PDFViewController()
        webViewController.webView = webView
        
        let navigationController = UINavigationController(rootViewController: webViewController)
        // Add a close button that dismisses the web view controller.
        webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(dismissController(_:)))
        // Present the document.
        presentViewController(navigationController, animated: true, completion: nil)
    }
    func dismissController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

