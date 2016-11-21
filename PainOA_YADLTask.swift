//
//  PainOA_YADLTask.swift
//  ORKSample
//
//  Created by Admin on 8/15/16.
//  Copyright © 2016 Apple, Inc. All rights reserved.
//

import ResearchKit
import sdl_rkx

public class PainOA_YADLTask: ORKNavigableOrderedTask {
    var stepsArray = [ORKStep]()
    
    public init(identifier: String){
        
        //add summary step
        stepsArray.append(QuestionSteps.summaryStep("SummaryStep"))
        super.init(identifier: identifier, steps: stepsArray)
       
        //set navigation rules
        setNavigationRule()
        
    }
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavigationRule(){
        // Build navigation rules.
        let resultSelector = ORKResultSelector(resultIdentifier: "PainLocationTask")
        let predicateFormItem = ORKResultPredicate.predicateForBooleanQuestionResultWithResultSelector(resultSelector, expectedAnswer: false)
        let predicateTextChoice = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateFormItem])
        let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [predicateTextChoice], destinationStepIdentifiers: [stepsArray[0].identifier], defaultStepIdentifier: nil, validateArrays: true)
        super.setNavigationRule(predicateRule, forTriggerStepIdentifier:"PainLocationTask")
    }
}

class QuestionSteps{
    
    //creates a boolean question step with given text and identifier
   class func boolStep(identifier: String,title: String) -> ORKQuestionStep{
        let boolStep = ORKQuestionStep(identifier: identifier)
        boolStep.title = NSLocalizedString(title, comment: "")
        boolStep.answerFormat = ORKBooleanAnswerFormat()
        boolStep.optional = false
        return boolStep
    }
    //create an open text question
    class func openStep(identifier: String,title: String) -> ORKQuestionStep{
        let openAnswerFormat = ORKTextAnswerFormat(maximumLength: 40)
        openAnswerFormat.multipleLines = false
        let openQuestionStepTitle = title
        let openQuestionStep = ORKQuestionStep(identifier: identifier, title: openQuestionStepTitle, answer: openAnswerFormat)
        openQuestionStep.placeholder = "Please specify"
        openQuestionStep.optional = false
        return openQuestionStep
    }
    //create a multiple choice question along with "other"
    class func choiceStep(identifier: String, title: String, choiceArray: [String], choiceStyle: ORKChoiceAnswerStyle ) -> ORKQuestionStep{
        
        let textChoices = getTextChoices(choiceArray)
        let choiceStep = ORKQuestionStep(identifier: identifier)
        let choiceStepAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(choiceStyle, textChoices: textChoices)
        choiceStep.title = NSLocalizedString(title, comment: "")
        choiceStep.answerFormat = choiceStepAnswerFormat
        choiceStep.optional = false
        return choiceStep
    }
    
    class func getTextChoices(choiceArray: [String]) -> [ORKTextChoice]{
        
        var textChoices = [ORKTextChoice]()
        
        textChoices = choiceArray.map { choice in
            return ORKTextChoice(text: choice, value: choice)
        }

        return textChoices
        
    }
    //create summaryStep
    class func summaryStep(identifier: String) -> ORKCompletionStep{
        let summaryStep = ORKCompletionStep(identifier: identifier)
        summaryStep.title = "All done!"
        summaryStep.text = "Thank you"
        return summaryStep
    }
    // Create instruction step
    class func instructionStep(instructionTitle: String, instructionText: String) -> ORKInstructionStep{
        let instructionStep = ORKInstructionStep(identifier: String("Instruction"))
        instructionStep.title = String(instructionTitle)
        instructionStep.text = String(instructionText)
        return instructionStep
    }

}
