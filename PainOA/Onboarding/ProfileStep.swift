//
//  ProfileStep.swift
//  RKitBase
//
//  Created by Admin on 9/6/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//

import ResearchKit

class ProfileStep{
    
    var profileSection = [[ProfileProperty](),[ProfileProperty](),[ProfileProperty](),[ProfileProperty]()]
    let sectionTitle = [Constants.DEMOGRAPHICS,
                        Constants.LIVING,
                        Constants.ENDOMETRIOSIS,
                        Constants.CONTACT]
    let stepTitle = "Profile"
    let stepText = "Please fill out your profile information"
    let numSections = 4
    var stepIdentifier = ""
    
    init(identifier: String, propertiesFileName: String) {

        //get the data for the profile properties
        //Read json file data to calss variables
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file with Profile values in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (Profile data)")
        }
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        guard let completeJSON = jsonData as? [String: AnyObject],
            let profileArrayJSON = completeJSON["ProfileValues"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        //add properties from Json to an array
        for i in 0..<profileArrayJSON.count{
            let property = (profileArrayJSON[i] as? [String: AnyObject])!
            let profileTitle = (property["profileTitle"] as? String)!
            let detailTitle = (property["detailTitle"] as? String)!
            let prompt = (property["prompt"] as? String)!
            let hideString = (property["hide"] as? String)!
            let hide = (hideString == "true")
            let section = (property["section"] as? String)!
            let choiceList = (property["choices"] as? [String])!
            switch (section){
            case sectionTitle[0]:
                profileSection[0].append(ProfileProperty(detail: detailTitle, profile: profileTitle, promptString: prompt, choiceList: choiceList, hidden: hide, sectionTitle: section))
            case sectionTitle[1]:
                profileSection[1].append(ProfileProperty(detail: detailTitle, profile: profileTitle, promptString: prompt, choiceList: choiceList, hidden: hide, sectionTitle: section))
            case sectionTitle[2]:
                profileSection[2].append(ProfileProperty(detail: detailTitle, profile: profileTitle, promptString: prompt, choiceList: choiceList, hidden: hide, sectionTitle: section))
            case sectionTitle[3]:
                profileSection[3].append(ProfileProperty(detail: detailTitle, profile: profileTitle, promptString: prompt, choiceList: choiceList, hidden: hide, sectionTitle: section))
            default:
                print("One or more properties have a bad section title, or sections titles poorly declared")
            }
        }
        stepIdentifier = identifier
    }
    
    func getSteps() -> [ORKStep]{
        var stepsArray = [ORKFormStep]()
        for i in 0..<4 {
            let step =  ORKFormStep(identifier: sectionTitle[i], title: "Profile", text: sectionTitle[i])
            var formItems = [ORKFormItem]()
            for j in 0..<profileSection[i].count {
                let formItemText = profileSection[i][j].prompt
                let formItemTitle = profileSection[i][j].detailTitle
                var textChoices = profileSection[i][j].choices.map({choice in ORKTextChoice(text: choice, value: choice)
                })
                if formItemTitle == Constants.AGE {
                    let intArray: [Int] = Array(1900...2016)
                    let stringArray = intArray.map { String($0) }
                    textChoices = stringArray.map({choice in ORKTextChoice(text: choice, value: choice)})
                    
                }
                let answerFormat = ORKAnswerFormat.valuePickerAnswerFormatWithTextChoices(textChoices)
                let formItem = ORKFormItem(identifier: formItemTitle, text: formItemText, answerFormat: answerFormat)
                formItem.placeholder = NSLocalizedString("Not Set", comment: "")
                formItem.optional = false
                formItems.append(formItem)
            }
            step.formItems = formItems
            step.optional = false
            stepsArray.append(step)
        }
        let answerFormatEmail = ORKAnswerFormat.emailAnswerFormat()
        let stepEmail = ORKFormItem(identifier: Constants.EMAIL, text: "What is your email?", answerFormat: answerFormatEmail)
        stepEmail.placeholder = "Not Set"
        stepsArray[3].formItems?.removeLast()
        stepsArray[3].formItems?.append(stepEmail)
        
        return stepsArray
    }
}
