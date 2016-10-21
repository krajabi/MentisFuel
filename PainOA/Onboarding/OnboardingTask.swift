//
//  OnboardingTask.swift
//  RKitBase
//
//  Created by Admin on 9/23/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import UIKit
import ResearchKit

// This subclass was created because once a user declines to agree the survey needs to quit
class OnboardingTask: ORKNavigableOrderedTask {
    let declineID = "declineID"
    let declineTitle = "Consent Declined"
    let declineText = "Unfortunately you cannot participate in the study if you don’t complete or agree to the informed consent. No data has been collected from you so far from your or your device. If you wish to participate, then please complete the consent process.\n\nIf you have any questions or concerns about the study you can email us at citizenendo@columbia.edu"
    
    override func stepAfterStep(step: ORKStep?, withResult result: ORKTaskResult) -> ORKStep? {
        if step?.identifier == declineID{
            return nil
        }
        if (step as? ORKConsentReviewStep) != nil {
            let consent = result.stepResultForStepIdentifier((step?.identifier)!)
            if(consent != nil){
                let consentResults = consent!.results
                let consentBool = (consentResults![0] as! ORKConsentSignatureResult).consented
                if !consentBool {
                    let declineStep = ORKInstructionStep(identifier: declineID)
                    declineStep.title = declineTitle
                    declineStep.text = declineText
                    return declineStep
                }
            }
        }
        return super.stepAfterStep(step, withResult: result)
    }

}
