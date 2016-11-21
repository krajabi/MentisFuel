//
//  jsonToTask.swift
//  RKitBase
//
//  Created by Admin on 9/29/16.
//  Copyright © 2016 Neil Lakin. All rights reserved.
//
//Ely- This is an incomplete class designed to create surveys from JSONs in the format used by the ResearchStack sample app (which does a similar thing)
//as of now it is missing the answerFormat implementation and navigation rule. In order to implement them you must look at the formatting in the researchstack
//sample app. Look for SmartSurveyTask inside Skin in research stack to see what I am trying to emulate (it also has the json formatting rules there)
// Once this is completed you can also add an implementation for the creation of a consent survey from here. Essentialy all surveys should be created from json files
// with a shared format with ResearchStack. This will eliminate a lot of unneeded code from this app and will make it much more organized. 
//
// When we started writing this app the specs were constantly changing and we were inexperienced. If I had more time I would have finished writing this and converting the app to 
//use it. Hope it is implemented in the future. for any questions feel free to contact me.

import Foundation
import ResearchKit

class JsonHandler {
    //JSON types
    static let SURVEY = "survey"
    static let CONSENT = "consent"
    
    //element type
    static let INSTRUCTION = "SurveyTextOnly"
    static let SUMMARY = "SurveySummary"
    static let QUESTION = "SurveyQuestion"
    static let FORM_STEP = "SurveyForm"
    
    //Answer Formats

    static func getTask(fileName: String) -> ORKNavigableOrderedTask {
        
        let completeJSON = getJsonData(fileName)
        var steps = [ORKStep]()
        let identifier = completeJSON[JsonConstants.Task.IDENTIFIER] as! String
        let elements = completeJSON[JsonConstants.Task.ELEMENTS] as! [AnyObject]
        let task: ORKNavigableOrderedTask
        
        switch completeJSON[JsonConstants.Task.TYPE] as! String {
        case SURVEY:
            steps = getSurveySteps(elements)
            task =  ORKNavigableOrderedTask(identifier: identifier, steps: steps)
            //TODO: add navigation stuff
        case CONSENT:
           // steps = getConsentSections(elements)
            task =  ORKNavigableOrderedTask(identifier: identifier, steps: steps)
        default:
            fatalError("Incorrect Task Type in \(fileName)")
        }
        
        return task
    }
    
    private static func getJsonData(fileName:String) -> [String: AnyObject]{
        
        guard let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
            else {
                fatalError("Unable to locate \(fileName) file in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content \(filePath)")
        }
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        guard let completeJSON = jsonData as? [String: AnyObject]
            else { fatalError("JSON Parse Error")}
        return completeJSON
    }
    
    private static func getSurveySteps(stepsJSON: [AnyObject]) -> [ORKStep]{
        var steps = [ORKStep]()
        for i in 0..<stepsJSON.count{
            let stepJSON = (stepsJSON[i] as? [String: AnyObject])!
            var step: ORKStep
            let type = (stepJSON[JsonConstants.Step.TYPE] as? String)!

            switch type{
            case INSTRUCTION:
                step = getInstructionStep(stepJSON)
            case SUMMARY:
                step = getCompletionStep(stepJSON)
            case QUESTION:
                step = getQuestionStep(stepJSON)
            case FORM_STEP:
                step = getFormStep(stepJSON)
            default:
             fatalError("Incorrect JSON Step Type ")
            }
            steps.append(step)
        }
        return steps
    }
    // creates an instructionstep
    private static func getInstructionStep(stepJSON: [String: AnyObject]) -> ORKStep{
        let identifier = (stepJSON[JsonConstants.Step.IDENTIFIER] as? String)!
        let step = ORKInstructionStep(identifier: identifier)
        step.title = (stepJSON[JsonConstants.Step.TITLE] as? String)!
        step.text = (stepJSON[JsonConstants.Step.TEXT] as? String)!
        return step
    }
    // creates a completionstep
    private static func getCompletionStep(stepJSON: [String: AnyObject]) -> ORKStep{
        let identifier = (stepJSON[JsonConstants.Step.IDENTIFIER] as? String)!
        let step = ORKCompletionStep(identifier: identifier)
        step.title = (stepJSON[JsonConstants.Step.TITLE] as? String)!
        step.text = (stepJSON[JsonConstants.Step.TEXT] as? String)!
        return step
    }
    //creates a questionstep
    private static func getQuestionStep(stepJSON: [String: AnyObject]) -> ORKStep{
        var optional = false
        if stepJSON[JsonConstants.Step.OPTIONAL] != nil {
            optional = (stepJSON[JsonConstants.Step.OPTIONAL] as? Bool)!
        }
        let identifier = (stepJSON[JsonConstants.Step.IDENTIFIER] as? String)!
        let answerFormat = getAnswerFormat((stepJSON[JsonConstants.Step.CONSTRAINTS] as? [AnyObject])!)
        let title = (stepJSON[JsonConstants.Step.TITLE] as? String)!
        let text = (stepJSON[JsonConstants.Step.TEXT] as? String)!
        let step = ORKQuestionStep(identifier: identifier, title: title, text: text, answer: answerFormat)
        step.optional = optional
        return step
    }
    //creates a formstep
    private static func getFormStep(stepJSON: [String: AnyObject]) -> ORKStep{
        var optional = false
        let identifier = (stepJSON[JsonConstants.Step.IDENTIFIER] as? String)!

        if stepJSON[JsonConstants.Step.OPTIONAL] != nil {
            optional = (stepJSON[JsonConstants.Step.OPTIONAL] as? Bool)!
        }
        let itemsJSON = (stepJSON[JsonConstants.Step.FORM_ITEMS] as? [AnyObject])!
        var formItems = [ORKFormItem]()
        for i in 0..<itemsJSON.count {
            let itemJSON = (itemsJSON[i] as? [String: AnyObject])!
            var optional = false
            if itemJSON[JsonConstants.Item.OPTIONAL] != nil {
                optional = (itemJSON[JsonConstants.Item.OPTIONAL] as? Bool)!
            }
            let identifier = (itemJSON[JsonConstants.Item.IDENTIFIER] as? String)!
            let text = (itemJSON[JsonConstants.Item.TITLE] as? String)!
            
            let answerFormat = getAnswerFormat((itemJSON[JsonConstants.Item.CONSTRAINTS] as? [AnyObject])!)
            let formItem = ORKFormItem(identifier: identifier, text: text, answerFormat: answerFormat, optional: optional)
            formItems.append(formItem)
        }
        let step = ORKFormStep(identifier: identifier)
        step.formItems = formItems
        step.title = (stepJSON[JsonConstants.Step.TITLE] as? String)!
        step.text = (stepJSON[JsonConstants.Step.TEXT] as? String)!
        step.optional = optional
        return step
    }
    
    private static func getAnswerFormat(constraints: [AnyObject]) -> ORKAnswerFormat {
        //incomplete
        return ORKAnswerFormat()
    }
    private static func getConsentSections(stepsJSON: [AnyObject]) -> [ORKStep]{
        //TODO: implement in future
        return [ORKStep]()
    }

}
//This is where the JSON formatting is stored
struct JsonConstants{
    struct Task {
        static let IDENTIFIER = "identifier"
        static let ELEMENTS = "elements"
        static let TYPE = "type"
    }
    struct Step {
        static let IDENTIFIER = "identifier"
        static let TITLE = "prompt"
        static let TEXT = "promptDetail"
        static let TYPE = "type"
        static let FORM_ITEMS = "formItemS"
        static let OPTIONAL = "optional"
        static let CONSTRAINTS = "constraints"
    }
    struct Item {
        static let IDENTIFIER = "identifier"
        static let TITLE = "prompt"
        static let OPTIONAL = "optional"
         static let CONSTRAINTS = "constraints"

    }
}
