//
//  LocalNotification.swift
//  RKitBase
//
//  Created by Admin on 8/24/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import Foundation
import UIKit

class LocalNotification {
    
    struct dailyStrings {
        static let array: [String] = ["Remember to fill out your medication log!",
                                      "Don't forget to take report your pain!",
                                      "Make sure you remember to share your results!",
                                      "Feeling pain? Fill out the pain task.",
                                      "Did you take medication today? Update your medication log.",
                                      "Have you reported your pain and medication, share with your physician!"]
    }
    
    class func registerNotification(fireDate: NSDate, alertBody: String, surveyType: String) {
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.alertBody = alertBody
        //only repeat survey if it's daily
        if surveyType == Constants.PAIN_LOCATION_SURVEY {
            notification.repeatInterval = NSCalendarUnit.Day
        }
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["SurveyType": surveyType]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func createFireDate(inDays: Int) -> NSDate {
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let NSHour = NSUserDefaults.standardUserDefaults().integerForKey(Constants.HOUR)
        let NSMinute = NSUserDefaults.standardUserDefaults().integerForKey(Constants.MINUTE)
        var fireDate = cal.dateBySettingHour(NSHour, minute: NSMinute, second: 0, ofDate: NSDate(), options: NSCalendarOptions())! //todo: set minute
        if inDays != 0 { //if notification supposed to be in a few days time
            fireDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: inDays, toDate: fireDate, options: [])!
        } else if fireDate.timeIntervalSinceDate(NSDate()) < 0 { //if too late in the day for today's notification, set notification for tomo
            fireDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: +1, toDate: fireDate, options: [])!
        }
        return fireDate
    }
    
    class func registerMonthlyNotification(){
        LocalNotification.deleteNotification(Constants.PAIN_MEDICATION_SURVEY)
        let daysSinceMonthlySurvey = LocalNotification.getNumberOfDaysBetweenDates(
            NSUserDefaults.standardUserDefaults().objectForKey(Constants.DATE_OF_LAST_MONTHLY_SURVEY_COMPLETION) as! NSDate, laterDate: NSDate())
        var inDays = 30 - daysSinceMonthlySurvey
        if inDays < 0 { //make sure no negative days
            inDays = 0
        }
        let fireDate = createFireDate(inDays)
        registerNotification(fireDate, alertBody: Constants.MONTHLY_REMINDER_TEXT, surveyType: Constants.PAIN_LOCATION_SURVEY)
    }
    
    class func registerDailyNotification(inDays: Int = 0){
        deleteNotification(Constants.PAIN_LOCATION_SURVEY) //just to be safe!
        let fireDate = createFireDate(inDays)
        let randomIndex = Int(arc4random_uniform(UInt32(dailyStrings.array.count)))
        registerNotification(fireDate, alertBody: dailyStrings.array[randomIndex], surveyType: Constants.PAIN_LOCATION_SURVEY)
    }
    
    class func deleteNotification(surveyTypeString: String){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]! {
            if let userInfo = notification.userInfo {
                let surveyType = userInfo["SurveyType"] as! String
                if surveyType == surveyTypeString {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
        }
    }
    
    class func deleteAllNotifications() {
        print("unregistering from notification")
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    class func getNumberOfDaysBetweenDates(earlierDate: NSDate, laterDate: NSDate) -> Int {
        //return number of days between two dates, ignoring the hours components
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(earlierDate)
        let date2 = calendar.startOfDayForDate(laterDate)
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        
        return components.day
    }
    
}
