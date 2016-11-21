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

class OnboardingViewController: UIViewController {
    // MARK: IB actions
    
    @IBAction func joinButtonTapped(sender: UIButton) {
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        
        let healthDataStep = HealthDataStep(identifier: "Health")
        
        let signature = consentDocument.signatures!.first!
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
        
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join the Developer Health Research Study."
        
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        passcodeStep.text = "Now you will create a passcode to identify yourself to the app and protect access to information you've entered."
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard."
        completionStep.text = "Thank you for joining this study."
        
        let orderedTask = ORKNavigableOrderedTask(identifier: "Join", steps: eligibilityTask+[consentStep, reviewConsentStep, healthDataStep, passcodeStep, completionStep])
       
        //rules for eligibility navigation
        var resultSelector = ORKResultSelector(stepIdentifier: "EligibilityFormStep", resultIdentifier: "EligibilityFormItem01")
        let predicateFormItem01 = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "Yes")
        resultSelector = ORKResultSelector(stepIdentifier: "EligibilityFormStep", resultIdentifier: "EligibilityFormItem02")
        let predicateFormItem02 = ORKResultPredicate.predicateForBooleanQuestionResultWithResultSelector(resultSelector, expectedAnswer: true)
        
        let predicateEligible = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateFormItem01, predicateFormItem02])
        let predicateRule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [ (predicateEligible, "EligibilityEligibleStep") ])
        
        orderedTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: "EligibilityFormStep")
        
        // Add end direct rules to skip unneeded steps
        let directRule = ORKDirectStepNavigationRule(destinationStepIdentifier: ORKNullStepIdentifier)
        orderedTask.setNavigationRule(directRule, forTriggerStepIdentifier: "EligibilityIneligibleStep")
        
       let taskViewController = ORKTaskViewController(task: orderedTask, taskRunUUID: nil)
        taskViewController.delegate = self

        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    private var eligibilityTask: [ORKStep] {
        //TEST AREA!!!!
        /*
        guard let filePath = NSBundle.mainBundle().pathForResource("ValidationSurvey2", ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        guard let completeJSON = jsonData as? [String: AnyObject],
            let surveyProperties = completeJSON["surveyProperties"] as? [String: AnyObject],
            let surveyIntro = completeJSON["surveyIntro"] as? [String: AnyObject],
            let surveySummary = completeJSON["surveySummary"] as? [String: AnyObject],
            let surveySteps = completeJSON["surveySteps"] as? [AnyObject],
            let surveyQuestions=surveySteps[0]["questions"] as? [AnyObject],
            let question1=surveyQuestions[0] as?[String: AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        print("\(surveySteps[1]["textValues"]!![3]! as! String)")*/
        
        //END TEST AREA!!
        // Intro step
        let introStep = ORKInstructionStep(identifier: "EligibilityIntoStep")
        introStep.title = NSLocalizedString("Eligibility Task Example", comment: "")
        let eligibilityPrompt = "Please answer the following questions:"
        // Form step
        let formStep = ORKFormStep(identifier: "EligibilityFormStep")
        formStep.title = NSLocalizedString("Eligibility", comment: "")
        formStep.text = eligibilityPrompt
        formStep.optional = false
        
        // Form items
        let textChoices : [ORKTextChoice] = [ORKTextChoice(text: "Yes, I regularly menstrate", value: "Yes"), ORKTextChoice(text: "Yes, but I don't menstruate at the moment", value: "Yes"), ORKTextChoice(text: "No, I have not started menstruating", value: "No")]
        let answerFormat = ORKTextChoiceAnswerFormat(style: ORKChoiceAnswerStyle.SingleChoice, textChoices: textChoices)
        let formItem01 = ORKFormItem(identifier: "EligibilityFormItem01", text: "Have you ever had a menstrual cycle?", answerFormat: answerFormat)
        formItem01.optional = false
        let boolAnswerFormat = ORKBooleanAnswerFormat()
        let formItem02 = ORKFormItem(identifier: "EligibilityFormItem02", text: "Have you experienced symptoms of Endometriosis in the past 3 months?", answerFormat: boolAnswerFormat)
        formItem02.optional = false
        
        
        formStep.formItems = [
            formItem01,
            formItem02
        ]
        
        // Ineligible step
        let ineligibleStep = ORKInstructionStep(identifier: "EligibilityIneligibleStep")
        ineligibleStep.title = NSLocalizedString("You are ineligible to join the study", comment: "")
        
        // Eligible step
        let eligibleStep = ORKCompletionStep(identifier: "EligibilityEligibleStep")
        eligibleStep.title = NSLocalizedString("You are eligible to join the study", comment: "")
        
        // Create the task
        let eligibilityTask = [
            introStep,
            formStep,
            ineligibleStep,
            eligibleStep
            ]
        
        return eligibilityTask
    }

}

extension OnboardingViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
            case .Completed:
                //This step checks the eligibility answers in EligibilityFormStep
                // continues only if Eligibile
                let taskResult = taskViewController.result.stepResultForStepIdentifier("EligibilityFormStep")!
                let results = taskResult.results as! [ORKQuestionResult]
                let firstResult = results[0] as! ORKChoiceQuestionResult
                let secondResult = results[1] as! ORKBooleanQuestionResult
                let firstValue = (firstResult.choiceAnswers! as! [String])[0]
        
                let booleanAnswer1 = firstValue.isEqual("Yes")
                let booleanAnswer2 = secondResult.booleanAnswer!

                if  booleanAnswer1 && booleanAnswer2.boolValue{
                    performSegueWithIdentifier("unwindToStudy", sender: nil)
                }
                else{
                    dismissViewControllerAnimated(true, completion: nil)
                }
            case .Discarded, .Failed, .Saved:
                dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, viewControllerForStep step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        
        return nil
    }
    
}
