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

import ResearchKit

class ConsentDocument: ORKConsentDocument {
    // MARK: Properties
    let consentArray = Constants.Consent.CONSENT_TEXT
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        title = NSLocalizedString(Constants.Consent.CONSENT_TITLE, comment: "")
        
        let sectionTypes: [ORKConsentSectionType] = [
            .Overview,
            .DataGathering,
            .Privacy,
            .DataUse,
            .TimeCommitment,
            .StudySurvey,
            .StudyTasks,
            .Withdrawing,
            .Custom
        ]
        
        sections = zip(sectionTypes, consentArray).map { sectionType, consentArray in
            let section = ORKConsentSection(type: sectionType)
            
            let localizedConsentArray = NSLocalizedString(consentArray, comment: "")
            let localizedSummary = localizedConsentArray.componentsSeparatedByString(".")[0] + "."
            
            section.summary = localizedSummary
            section.content = localizedConsentArray
            
            return section
        }
        sections![5].title = "Potential Benefits"
        sections![5].customLearnMoreButtonTitle = "Learn more about potential benefits"

        sections![6].title = "Potential Risks"
        sections![6].customLearnMoreButtonTitle = "Learn more about potential risks"

        sections![7].title = "Voluntary Participation"
        sections![7].customLearnMoreButtonTitle = "Learn more about voluntary participation in the study"
        sections![7].customImage = UIImage(named: "withdraw")
        
        sections![8].title = "Issues to Consider"
        sections![8].customLearnMoreButtonTitle = "Learn more about issues you should condiser"
        sections![8].customImage = UIImage(named: "visitingDoctor")

        let signature = ORKConsentSignature(forPersonWithTitle: "Participant", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ORKConsentSectionType: CustomStringConvertible {

    public var description: String {
        switch self {
            case .Overview:
                return "Overview"
                
            case .DataGathering:
                return "DataGathering"
                
            case .Privacy:
                return "Privacy"
                
            case .DataUse:
                return "DataUse"
                
            case .TimeCommitment:
                return "TimeCommitment"
                
            case .StudySurvey:
                return "StudySurvey"
                
            case .StudyTasks:
                return "StudyTasks"
                
            case .Withdrawing:
                return "Bloopy"
                
            case .Custom:
                return "Custom"
                
            case .OnlyInDocument:
                return "OnlyInDocument"
        }
    }
}
