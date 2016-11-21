//
//  ValidationSurveyTask.swif
//
//  Created by Admin on 8/11/16.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

import ResearchKit
import sdl_rkx

public class ValidationSurveyTask {
    var identifierForTask = String()
    init(identifier: String){
        identifierForTask = identifier
    }
    func getSurvey() -> ORKOrderedTask{
        //Read json file data to calss variables
        guard let filePath = NSBundle.mainBundle().pathForResource("ValidTrial1", ofType: "json")
            else {
                fatalError("Unable to location file with vaidation survey in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (ValidTrial1)")
        }
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        guard let completeJSON = jsonData as? [String: AnyObject],
            //let surveyProperties = completeJSON["surveyProperties"] as? [String: AnyObject],
            let surveyIntro = completeJSON["surveyIntro"] as? [String: AnyObject],
            let surveySummary = completeJSON["surveySummary"] as? [String: AnyObject],
            let surveySteps = completeJSON["surveySteps"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        
        //Create the ORKOrderedTask
        var steps = [ORKStep]()
        
        //get introduction step
        let introStep = getInstructionStep(surveyIntro)
        steps += [introStep]
        
        // Create the array of SurveySteps
        var surveyStepsArray = [SurveyStep]()
        for i in 0..<surveySteps.count{
            surveyStepsArray += [SurveyStep(step: (surveySteps[i] as? [String: AnyObject])!)]
        }
         
        // Form step
       // let formSteps = getFormSteps(surveyStepsArray)
        //steps += formSteps
        
        // MEDL step
        let medl = MEDLSpotAssessmentTask(identifier: "MEDL Spot Assessment", propertiesFileName: "ValidationSurveyTask", itemIdentifiers: nil)
        var medlSteps = medl.steps
        medlSteps.removeLast()
        steps += medlSteps
        
        // YADL step
        let yadl = YADLSpotAssessmentTask(identifier: "YADL Spot Assessment", propertiesFileName: "PainOA_YADL", activityIdentifiers: nil)
        var yadlSteps = yadl.steps
        yadlSteps.removeLast()
        steps += yadlSteps
        
        //get summary step
        let completionStep = getSummaryStep(surveySummary)
        steps += [completionStep]
        
        return ORKOrderedTask(identifier: identifierForTask, steps: steps)
    }
    func getInstructionStep(surveyIntro: [String: AnyObject]) -> ORKInstructionStep{
        // Create instruction step
        let instructionStep = ORKInstructionStep(identifier: String(surveyIntro["identifier"]))
        instructionStep.title = String(surveyIntro["title"]!)
        instructionStep.text = String(surveyIntro["text"]!)
        return instructionStep
    }
    func getSummaryStep(surveySummary: [String: AnyObject]) -> ORKCompletionStep{
        // Create summary step
        let summaryStep = ORKCompletionStep(identifier: String(surveySummary["identifier"]))
        summaryStep.title = String(surveySummary["title"]!)
        summaryStep.text = String(surveySummary["text"]!)
        return summaryStep

    }
    func getFormSteps(surveyStepsArray: [SurveyStep]) -> [ORKStep]{
        var formSteps = [ORKStep]()
        for i in 0..<surveyStepsArray.count {
            //check if its a single part questions or multi-part
            if surveyStepsArray[i].numQuestions == 1 {
                let formStep = ORKQuestionStep(identifier: "SurveyStep\(i+1)")
                formStep.title = surveyStepsArray[i].title
                formStep.text = surveyStepsArray[i].questions[0].prompt
                formStep.optional = false
                var stepAnswerFormat = ORKAnswerFormat()
                if surveyStepsArray[i].numAnswers == 2 {
                    stepAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
                }
                else {
                    //create the text choices and scale answer
                    var textChoices = [ORKTextChoice]()
                    for j in 0..<surveyStepsArray[i].numAnswers {
                        textChoices += [ORKTextChoice(text: surveyStepsArray[i].textChoice[j], value: j+1)]
                    }
                    stepAnswerFormat = ORKAnswerFormat.textScaleAnswerFormatWithTextChoices(textChoices, defaultIndex: NSIntegerMax, vertical: false)
                }
                formStep.answerFormat = stepAnswerFormat
                formSteps.append(formStep)

            } else{
                let formStep = ORKFormStep(identifier: "SurveyStep\(i+1)")
                formStep.title = surveyStepsArray[i].title
                formStep.text = surveyStepsArray[i].text
                formStep.optional = false
                var stepAnswerFormat = ORKAnswerFormat()
                if surveyStepsArray[i].numAnswers == 2 {
                    stepAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
                }
                else {
                    //create the text choices and scale answer
                    var textChoices = [ORKTextChoice]()
                    for j in 0..<surveyStepsArray[i].numAnswers {
                        textChoices += [ORKTextChoice(text: surveyStepsArray[i].textChoice[j], value: j+1)]
                    }
                    stepAnswerFormat = ORKAnswerFormat.textScaleAnswerFormatWithTextChoices(textChoices, defaultIndex: NSIntegerMax, vertical: false)
                }
                
                //create the questions in the form
                formStep.formItems = [ORKFormItem]()
                for j in 0..<surveyStepsArray[i].numQuestions {
                    formStep.formItems!.append(ORKFormItem(identifier: surveyStepsArray[i].questions[j].identifier, text: surveyStepsArray[i].questions[j].prompt, answerFormat: stepAnswerFormat))
                   // print("questionPrompt: \(surveyStepsArray[i].questions[j].prompt)")//TESTING PURPOSES
                    formStep.formItems![j].optional = false
                }
                formSteps.append(formStep)
            }

        }
        return formSteps
    }
}

public class SurveyQuestion{
    
    var identifier = String()
    var prompt = String()
    
    public init(question: [String: AnyObject]){
        identifier = (question["identifier"] as? String)!
        prompt = (question["prompt"] as? String)!
    }
}
public class SurveyStep{
    
    var title = String()
    var text = String()
    //add identifier?
    var numAnswers=0
    var numQuestions=0
    var textChoice = [String]()
    var questions = [SurveyQuestion]()
    
    public init(step: [String: AnyObject]){
        title = (step["title"] as? String)!
        text = (step["text"] as? String)!
        numAnswers = (step["numAnswers"] as? Int)!
       // print("numAnswers: \(numAnswers)")//TESTING PURPOSES
        let textChoiceArray = (step["textChoices"] as? [String: AnyObject])!
        for i in 0..<numAnswers{
            textChoice.append((textChoiceArray[String(i+1)] as? String)!)
        }
        numQuestions = (step["questions"] as? [AnyObject])!.count
       // print("numQuestions: \(numQuestions)")//TESTING PURPOSES
        for i in 0..<numQuestions{
            questions += [SurveyQuestion(question: (step["questions"] as? [AnyObject])![i] as! [String : AnyObject])]
        }
    }
}
