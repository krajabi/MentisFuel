//
//  TrackViewController.swift
//  RKitBase
//
//  Created by Admin on 9/2/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import ResearchKit
import CoreLocation

class TrackViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var painLocationImage: UIButton!
    @IBOutlet weak var painMedicationImage: UIButton!
    
    override func loadView() {
        super.loadView()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        painLocationImage.userInteractionEnabled = true
        painLocationImage.setImage(Constants.Images.PAIN_LOCATION_SURVEY, forState: UIControlState.Normal)

        painMedicationImage.setImage(Constants.Images.PAIN_MEDICATION_SURVEY, forState: UIControlState.Normal)
        painMedicationImage.userInteractionEnabled = true
        }

    //Actions from buttons
    
    @IBAction func painLocationButtonPressed(_: UIButton) {
        let taskViewController: ORKTaskViewController;
        taskViewController = ORKTaskViewController(task: PainOA_YADLTask(identifier: Constants.Identifiers.PAINOA_YADL), taskRunUUID: NSUUID());
        initTask(taskViewController);
    }
    
    @IBAction func painMedicationButtonPressed(_: UIButton) {
        let taskViewController: ORKTaskViewController;
        let validationSurvey = ValidationSurveyTask(identifier: Constants.Identifiers.VALIDATION_SURVEY);
        taskViewController = ORKTaskViewController(task: validationSurvey.getSurvey(), taskRunUUID: NSUUID());
        initTask(taskViewController);
    }
    
    @IBAction func shareResultsButtonPressed(_: UIButton) {
        let taskViewController: ORKTaskViewController;
        taskViewController = ORKTaskViewController(task: PainOA_YADLTask(identifier: Constants.Identifiers.PAINOA_YADL), taskRunUUID: NSUUID());
        initTask(taskViewController);
    }
    
    func initTask(taskViewController: ORKTaskViewController) {
        taskViewController.delegate = self
        navigationController?.presentViewController(taskViewController, animated: true, completion: nil)
    }
}

extension TrackViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Handle results using taskViewController.result
        guard reason == .Completed
            else {
                taskViewController.dismissViewControllerAnimated(true, completion: nil)
                return
        }
        guard let taskResult: ORKTaskResult = taskViewController.result
            else {
                taskViewController.dismissViewControllerAnimated(true, completion: nil)
                return
        }
        print(taskResult.identifier)

        switch taskResult.identifier {
        case Constants.Identifiers.VALIDATION_SURVEY:
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: Constants.DATE_OF_LAST_MONTHLY_SURVEY_COMPLETION)
            print("finished validation task!")

            LocalNotification.deleteNotification(Constants.PAIN_MEDICATION_SURVEY)
            let monthlyReminderBool = NSUserDefaults.standardUserDefaults().boolForKey(Constants.Settings.GET_MONTHLY_REMINDER)
            if monthlyReminderBool {
                LocalNotification.registerMonthlyNotification()
            }
        case Constants.Identifiers.PAINOA_YADL:
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: Constants.DATE_OF_LAST_DAILY_SURVEY_COMPLETION)
            let days = NSUserDefaults.standardUserDefaults().integerForKey(Constants.DAYS_COMPLETED)
            NSUserDefaults.standardUserDefaults().setInteger(days + 1, forKey: Constants.DAYS_COMPLETED)
            print("finished daily task!")
            //don't reset the notification if you are currently muting them!
            if NSUserDefaults.standardUserDefaults().integerForKey(Constants.DAYS_TO_MUTE_DAILY_NOTIFICATION) <= 0 {
                //if you're not muting notifications, then set the new one to tomo, so today's doesn't go off
                LocalNotification.registerDailyNotification(1) //in 1 day
            }
        default:
            break
        }
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "Background screen White Version (fade out) – 3")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
