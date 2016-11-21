
//
//  ValidationSurveyTask.swif
//
//  Created by Admin on 8/11/16.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

import ResearchKit

public class BPNSSurveyTask {
    
    var identifierForTask = String()
    init(identifier: String){
        identifierForTask = identifier
    }
    
    func getSurvey() -> ORKOrderedTask{
        //Read json file data to calss variables
        guard let filePath = NSBundle.mainBundle().pathForResource("BPNS", ofType: "json")
            else {
                fatalError("Unable to location file with BPNS questions in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (BPNS)")
        }
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        guard let completeJSON = jsonData as? [String: AnyObject],
            //let surveyProperties = completeJSON["surveyProperties"] as? [String: AnyObject],
            let surveyIntro = completeJSON["surveyIntro"] as? [String: AnyObject],
            let surveyInstruction = completeJSON["surveyIntruction"] as? [String: AnyObject],
            let surveySummary = completeJSON["surveySummary"] as? [String: AnyObject],
            let surveySteps = completeJSON["surveySteps"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        
        //Create the ORKOrderedTask
        var steps = [ORKStep]()
        
        //get intro step
        let introStep = getIntroStep(surveyIntro)
       // steps += [introStep]
        
        //get introduction step
        let instructionStep = getInstructionStep(surveyInstruction)
        instructionStep.title = "Onboarding Survey"
        instructionStep.text = introStep.text! + "\n\n" + instructionStep.text!
        steps += [instructionStep]
        
        // Create the array of SurveySteps
        var surveyStepsArray = [SurveyStep]()
        for i in 0..<surveySteps.count{
            surveyStepsArray += [SurveyStep(step: (surveySteps[i] as? [String: AnyObject])!)]
        }
        
        // Form step
        let formSteps = getFormSteps(surveyStepsArray)
        steps += formSteps
        
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
    func getIntroStep(surveyIntro: [String: AnyObject]) -> ORKInstructionStep{
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
        var formSteps = [ORKQuestionStep]()
        //create ORKQuestionStep for every question in surveyStepsArray
        for i in 0..<surveyStepsArray.count {
            let formStep = ORKQuestionStep(identifier: "SurveyStep\(i+1)")
            formStep.title = surveyStepsArray[i].title
            formStep.text = surveyStepsArray[i].questions[0].prompt
            formStep.optional = false
            var stepAnswerFormat = ORKAnswerFormat()
            
            //create the scale text choices and values
            var textChoices = [ORKTextChoice]()
            for j in 0..<surveyStepsArray[i].numAnswers {
                textChoices += [ORKTextChoice(text: surveyStepsArray[i].textChoice[j], value: j+1)]
            }
            stepAnswerFormat = ORKAnswerFormat.scaleAnswerFormatWithMaximumValue(textChoices.count, minimumValue: 1, defaultValue: NSIntegerMax, step: 1, vertical: false, maximumValueDescription: textChoices[textChoices.count-1].text, minimumValueDescription: textChoices.first?.text )
          //  stepAnswerFormat = ORKAnswerFormat.textScaleAnswerFormatWithTextChoices(textChoices, defaultIndex: NSIntegerMax, vertical: false)
            formStep.answerFormat = stepAnswerFormat
            formSteps.append(formStep)
        }
        return formSteps
    }
}
