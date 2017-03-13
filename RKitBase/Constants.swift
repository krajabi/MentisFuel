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
    
    //PROFILE INFO
    static let FIRST_NAME="first_name"
    static let LAST_NAME="last_name"
    
    struct Images {
        static let red_text_green_color = UIImage(named: "red_text_green_color")!
        static let red_text_red_color = UIImage(named: "red_text_red_color")!
        static let green_text_green_color = UIImage(named: "green_text_green_color")!
        static let green_text_red_color = UIImage(named: "green_text_red_color")!
        static let blue_text_blue_color = UIImage(named: "blue_text_blue_color")!
        static let blue_text_yellow_color = UIImage(named: "blue_text_yellow_color")!
        static let yellow_text_blue_color = UIImage(named: "yellow_text_blue_color")!
        static let yellow_text_yellow_color = UIImage(named: "yellow_text_yellow_color")!

        static let BACKGROUND = UIImage(named: "BackgroundScreen")!
        static let STROOP_INSTRUCTIONS = UIImage(named: "instructions_stroop")
        static let morningfuel = UIImage(named: "morningfuel")!
        static let eveningfuel = UIImage(named: "eveningfuel")!
        static let SHARE_RESULTS = UIImage(named: "showmefuel")!
    }
    //SETTINGS INFO
    struct Consent {
        static let CONSENT_TITLE = "MentisFuel Study Consent Form"
       static let CONSENT_TEXT = [
            "Consent goes here."
        ]

    }
}
