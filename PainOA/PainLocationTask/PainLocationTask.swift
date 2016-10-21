//
//  PainLocationTask.swift
//  RKitBase
//
//  Created by Admin on 9/6/16.
//  Copyright © 2016 Ely Erez. All rights reserved.
//  
//  Note: this is an incomplete implementation of a custom researchkit survey based on a custom active task used to track pain
//  location and intensity on a human body (currently supports only a female body)

import ResearchKit

public class PainLocationTask: ORKNavigableOrderedTask {
    var stepsArray = [ORKStep]()
    let instructionTitle = "Today's Pain"
    let instructionText = "We will now ask you about your endometriosis related pain. Please click on the body areas where you experienced endometriosis-related pain today and choose an intensity level. If you did not experience any endometriosis-related pain simply click next to continue."
    let summaryTitle = "All done!"
    let summaryText = "Thank you"
    
    public init(identifier: String){
        
        //create an instruction step for the body map
        let instructionStep = ORKInstructionStep(identifier: identifier)
        instructionStep.title = String(instructionTitle)
        instructionStep.text = String(instructionText)
        
        //create the map step
        let bodyMapStep = PainStep(identifier: "bodyMapStep")
      
        //create a summary step
        let summaryStep = ORKCompletionStep(identifier: "PainLocationSummary")
        summaryStep.title = String(summaryTitle)
        summaryStep.text = String(summaryText)

        
        stepsArray = [instructionStep,bodyMapStep, summaryStep]
        super.init(identifier: identifier, steps: stepsArray)
        

        
    }
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
