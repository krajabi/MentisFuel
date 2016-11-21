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
import CoreLocation
import HealthKit

class OnboardingViewController: UIViewController {

    var steps = [ORKStep]()
    @IBOutlet var enableHealthKitButton: UIButton!
    lazy var healthStore = HKHealthStore()
    
    // MARK: IB actions
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: Constants.Images.BACKGROUND)
        //enableHealthKitButton.hidden = !HKHealthStore.isHealthDataAvailable()
    }
    
    @IBAction func enableHealthKit(sender: AnyObject) {
        let stepCount = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierStepCount)
        let sleepAnalysis = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)
        let birthDate = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)
        
        var shareTypes = Set<HKSampleType>()
        shareTypes.insert(stepCount!)
        shareTypes.insert(sleepAnalysis!)
        
        var readTypes = Set<HKObjectType>()
        readTypes.insert(stepCount!)
        readTypes.insert(sleepAnalysis!)
        readTypes.insert(birthDate!)

        healthStore.requestAuthorizationToShareTypes(shareTypes, readTypes: readTypes) { (success, error) -> Void in
            if success {
                print("success")
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
    }
    
    @IBAction func joinButtonTapped(sender: UIButton) {
        //Healthkit is commented out
        
        let consentSteps = getConsentSteps()
        let profileOnboardingSteps = getProfileOnboardingSteps()
        
        //Pascode is commented out
        //let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        //passcodeStep.text = "Now you will create a passcode to identify yourself to the app and protect access to information you've entered."

        steps += consentSteps
        steps += profileOnboardingSteps
        let onboardingTask = getTaskWithNavRules("Join", steps: steps)
        let taskViewController = ORKTaskViewController(task: onboardingTask, taskRunUUID: nil)
        taskViewController.delegate = self
        taskViewController.view.tintColor = Constants.Colors.BLUE

        presentViewController(taskViewController, animated: true, completion: nil)
    }
    

    private func getConsentSteps() -> [ORKStep] {
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        let signature = consentDocument.signatures!.first!
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
        reviewConsentStep.text = "Review the consent form"
        reviewConsentStep.reasonForConsent = "Please review the informed consent details. The next screen will require your signature if you choose to proceed."
        return [consentStep,reviewConsentStep]
    }
    private func getProfileOnboardingSteps() -> [ORKStep] {
        
        //ceate onboarding survey
        let instructionProfileStep = ORKInstructionStep(identifier: "InstructionProfileStep")
        instructionProfileStep.title = "Welcome aboard!"
        instructionProfileStep.text = "To begin we will need you to complete several steps.\n\nWe're going to start by asking you some questions about who you are. You can change these later in your profile."
        
        //create a profile survey
        let profileOnboarding = ProfileStep(identifier: "profileOnboardingStep", propertiesFileName: "Profile")
        
        let profileSteps = profileOnboarding.getSteps()
        return [instructionProfileStep]+profileSteps
    }
    
    private func getTaskWithNavRules(identifier: String, steps: [ORKStep]) -> OnboardingTask {
       
        let onboardingTask = OnboardingTask(identifier: identifier, steps: steps)

        //rules for eligibility navigation
        var resultSelector = ORKResultSelector(stepIdentifier: "EligibilityFormStep", resultIdentifier: "EligibilityFormItem01")
        let predicateFormItem01 = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "Yes1")
        let predicateFormItem03 = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "Yes2")
        resultSelector = ORKResultSelector(stepIdentifier: "EligibilityFormStep", resultIdentifier: "EligibilityFormItem02")
        let predicateFormItem02 = ORKResultPredicate.predicateForBooleanQuestionResultWithResultSelector(resultSelector, expectedAnswer: true)
        resultSelector = ORKResultSelector(stepIdentifier: "EligibilityFormStep", resultIdentifier: "EligibilityFormItem03")
        let predicateFormItem04 = ORKResultPredicate.predicateForBooleanQuestionResultWithResultSelector(resultSelector, expectedAnswer: true)
        
        let eligibleQ1 = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateFormItem01,predicateFormItem03])
        let predicateEligible = NSCompoundPredicate(andPredicateWithSubpredicates: [eligibleQ1, predicateFormItem02,predicateFormItem04])
        let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [predicateEligible], destinationStepIdentifiers: ["EligibilityEligibleStep"], defaultStepIdentifier: nil, validateArrays: true)
        
        onboardingTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: "EligibilityFormStep")
        
        // Add end direct rules to skip unneeded steps
        let directRule = ORKDirectStepNavigationRule(destinationStepIdentifier: ORKNullStepIdentifier)
        onboardingTask.setNavigationRule(directRule, forTriggerStepIdentifier: "EligibilityIneligibleStep")
        
        return onboardingTask
    }
    
}

extension OnboardingViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
            case .Discarded, .Failed, .Saved:
                dismissViewControllerAnimated(true, completion: nil)
            case .Completed:
                let consent = taskViewController.result.stepResultForStepIdentifier("ConsentReviewStep")
                var consentBool = false
                if(consent != nil){
                    let consentResults = consent!.results
                    consentBool = (consentResults![0] as! ORKConsentSignatureResult).consented
                }
                if  consentBool {
                    //register data from onboarding
                    registerOnboardingData(taskViewController)
                    performSegueWithIdentifier("unwindToStudy", sender: nil)
                }
                else{
                    dismissViewControllerAnimated(true, completion: nil)
                }
        }
    }
    
    func registerOnboardingData(taskViewController: ORKTaskViewController) {
        //register username
        registerUserName(taskViewController.result.stepResultForStepIdentifier("ConsentReviewStep")!)
        createConsentPDF(taskViewController.result.stepResultForStepIdentifier("ConsentReviewStep")!)
        setNSUserDefaults() //set today as the most recent time user did surveys
        updateProfileChoiceQuestion(taskViewController.result.stepResultForStepIdentifier(Constants.OSTEOARTHRITIS)!)
        updateProfileTextQuestion(taskViewController.result.stepResultForStepIdentifier(Constants.CONTACT)!)
        registerNotifications()
    }
    
    func registerUserName(taskResult: ORKStepResult){
        let results = taskResult.results as! [ORKConsentSignatureResult]!
        print("givenName:", results[0].signature?.givenName!)
        print("familyName:",results[0].signature?.familyName!)
        NSUserDefaults.standardUserDefaults().setObject(results[0].signature?.givenName!,
                                                        forKey: Constants.FIRST_NAME)
        NSUserDefaults.standardUserDefaults().setObject(results[0].signature?.familyName!,
                                                        forKey: Constants.LAST_NAME)
    }
    
    func createConsentPDF(taskResult: ORKStepResult){
        print("creating consent pdf")
        let results = taskResult.results as! [ORKConsentSignatureResult]!
        let signatureResult = results.first!
        let consentDocument = ConsentDocument()
        signatureResult.applyToDocument(consentDocument)
        consentDocument.makePDFWithCompletionHandler { (data, error) -> Void in
            let tempPath = NSTemporaryDirectory() as NSString
            let path = tempPath.stringByAppendingPathComponent("ConsentDocument.pdf")
            data?.writeToFile(path, atomically: true)
            print("saving consent document ", path)
        }    
    }
    
    func setNSUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let yesterdayDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let thirtyDaysAgoDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -30, toDate: NSDate(), options: [])
        //notifications page
        defaults.setObject(yesterdayDate, forKey: Constants.DATE_OF_LAST_DAILY_SURVEY_COMPLETION)
        defaults.setObject(thirtyDaysAgoDate, forKey: Constants.DATE_OF_LAST_MONTHLY_SURVEY_COMPLETION)
        defaults.setObject(thirtyDaysAgoDate, forKey: Constants.LAST_MUTE_DATE_CHECKED)
        defaults.setInteger(0, forKey:Constants.DAYS_TO_MUTE_DAILY_NOTIFICATION)
        //automatically set to 0: defaults.setInteger(0, forKey: Constants.DAYS_TO_MUTE_DAILY_NOTIFICATION)
        //momentary pain
        defaults.setObject([String](), forKey: Constants.PAIN_DOTS_FRONT)
        defaults.setObject([String](), forKey: Constants.PAIN_DOTS_BACK)
        defaults.setInteger(8, forKey: Constants.HOUR)
        defaults.setInteger(0, forKey: Constants.MINUTE)
        //settings  page
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.Settings.GET_MONTHLY_REMINDER)
        NSUserDefaults.standardUserDefaults().setObject(Constants.Settings.MUTE_OFF, forKey: Constants.Settings.MUTE_DAILY_REMINDER_DURATION)
        NSUserDefaults.standardUserDefaults().setObject(Constants.DEFAULT_NOTIFICATION_TIME, forKey: Constants.Settings.DAILY_NOTIFICATION_TIME)
    }
    
    func registerNotifications() {
        //get notification permissions from user
        print("registering notification")
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        //register notifications @ 8 pm today (if time hasn't passed yet)
        LocalNotification.registerDailyNotification()
        LocalNotification.registerMonthlyNotification()
    }
    
    func updateProfileChoiceQuestion(taskResult: ORKStepResult){
        print("in here")
        let results = taskResult.results as! [ORKChoiceQuestionResult]!
        for result in results {
            let temp = result.choiceAnswers![0] as! String
            NSUserDefaults.standardUserDefaults().setObject(temp, forKey: result.identifier)
        }
    }
    
    func updateProfileTextQuestion(taskResult: ORKStepResult){
        let results = taskResult.results as! [ORKTextQuestionResult]!
        for result in results {
            let emailAddress = result.textAnswer!
            NSUserDefaults.standardUserDefaults().setObject(emailAddress, forKey: result.identifier)
            print(emailAddress)
            print(result.identifier)
        }
    }
}
