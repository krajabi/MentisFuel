//
//  Constants.swift
//  RKitBase
//
//  Created by Admin on 8/24/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    //NSUserDefaults
    static let HAS_REGISTERED = "hasRegistered"
    static let DATE_OF_LAST_DAILY_SURVEY_COMPLETION = "DateOfLastDailySurveyCompletion"
    static let DATE_OF_LAST_MONTHLY_SURVEY_COMPLETION = "DateOfLastMonthlySurveyCompletion"
    static let LAST_MUTE_DATE_CHECKED = "lastDateChecked"
    static let DAYS_TO_MUTE_DAILY_NOTIFICATION = "daysToMuteDailyNotification"
    static let DEFAULT_NOTIFICATION_TIME = "8:00 PM"
    static let DAYS_COMPLETED = "daysCompleted"
    static let HOUR = "hour"
    static let MINUTE = "minute"
    
    //PROFILE INFO
    static let FIRST_NAME="first_name"
    static let LAST_NAME="last_name"
    
    //PROFILE CATEGORIES
    //if change, make sure values are updated in both ProfileStep and TrackViewController!!
    static let OSTEOARTHRITIS = "Osteoarthritis"
    static let CONTACT = "Contact"
    static let EMAIL = "Email"
    static let AGE = "Birth Year"
    
    //Notification content
    static let PAIN_MEDICATION_SURVERY_REMINDER = "Please take the PainOA pain medication survey"
    static let PAIN_LOCATION_SURVERY_REMINDER = "Please take the PainOA pain intensity and location survey"
    static let MONTHLY_REMINDER_TEXT = "Have you filled out your monthly survey?"
    
    
    //Survey types
    static let PAIN_LOCATION_SURVEY = "Pain Location Survey"
    static let PAIN_MEDICATION_SURVEY = "Pain Medication Survey"
    
    //Pain Dots
    static let PAIN_DOTS_FRONT = "painDotsFront"
    static let PAIN_DOTS_BACK = "painDotsBack"
    
    struct Colors {
        static let BLUE = UIColor(red:0.11, green:0.455, blue:0.737, alpha:1.0)
        static let OFF_WHITE = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        static let ColorMap10 = UIColor(red:1.0, green:0.0, blue:0.0, alpha:1.0)
        static let ColorMap9 = UIColor(red:1.0, green:0.10980392156862745, blue:0.0, alpha:1.0)
        static let ColorMap8 = UIColor(red:1.0, green:0.2196078431372549, blue:0.0, alpha:1.0)
        static let ColorMap7 = UIColor(red:1.0, green:0.3333333333333333, blue:0.0, alpha:1.0)
        static let ColorMap6 = UIColor(red:1.0, green:0.44313725490196076, blue:0.0, alpha:1.0)
        static let ColorMap5 = UIColor(red:1.0, green:0.5529411764705883, blue:0.0, alpha:1.0)
        static let ColorMap4 = UIColor(red:1.0, green:0.6666666666666666, blue:0.0, alpha:1.0)
        static let ColorMap3 = UIColor(red:1.0, green:0.7764705882352941, blue:0.0, alpha:1.0)
        static let ColorMap2 = UIColor(red:1.0, green:0.8862745098039215, blue:0.0, alpha:1.0)
        static let ColorMap1 = UIColor(red:1.0, green:1.0, blue:0.0, alpha:1.0)
    }
    struct Images {
        static let BACKGROUND = UIImage(named: "BackgroundScreen")!
        static let PAIN_LOCATION_SURVEY = UIImage(named: "painLocationButton")!
        static let PAIN_MEDICATION_SURVEY = UIImage(named: "painMedicationButton")!
        static let SHARE_RESULTS = UIImage(named: "shareResultsButton")!
    }
    //SETTINGS INFO
    struct Settings {
        static let GET_MONTHLY_REMINDER = "getMonthlyReminder"
        static let MUTE_DAILY_REMINDER_DURATION = "muteDailyReminderDuration"
        static let DAILY_NOTIFICATION_TIME = "dailyNotificationTime"
        static let MUTE_OFF = "On"
        static let MUTE_3_DAYS = "Mute for 3 Days"
        static let MUTE_1_WEEK = "Mute for 1 Week"
        static let MUTE_1_MONTH = "Mute for 1 Month"
        static let URL_STRING = "Find out more about this product and our development team"
        static let URL = "https://cornelltech-eli-lilly.github.io/Site/"
        static let EMAIL_STRING = "Contact Us"
        static let EMAIL = "mailto:support@PainOA.com"
    }
    struct Identifiers {
        static let HEALTH = "Health"
        static let PAINOA_YADL = "PainOA_YADL"
        static let PAINOA_MEDL = "PainOA_MEDL"
        static let VALIDATION_SURVEY = "ValidationSurveyTask"
        static let INTRO = ["introOneViewController","introTwoViewController"]
    }
    
    struct Consent {
        static let CONSENT_TITLE = "PainOA Study Consent Form"
       static let CONSENT_TEXT = [
            "Consent goes here."
        ]

    }
}
