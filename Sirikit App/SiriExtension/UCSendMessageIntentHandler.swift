/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The handler class for INSendMessageIntent.
*/

import Foundation
import Intents
import UnicornCore
import AVFoundation


class UCSendMessageIntentHandler: NSObject, INSendMessageIntentHandling {
    
    // MARK: 1. Resolve
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Swift.Void) {
        
        if let recipients = intent.recipients {
            var resolutionResults = [INPersonResolutionResult]()
            
            for recipient in recipients {
                
                //TODO: ReplaceUCAddressBookManager with Skills list
                let matchingContacts = UCAddressBookManager().contacts(matchingName: recipient.displayName)
                
                switch matchingContacts.count {
                    case 2 ... Int.max:
                        // We need Siri's help to ask user to pick one from the matches.
                        let disambiguationOptions: [INPerson] = matchingContacts.map { contact in
                            return contact.inPerson()
                        }

                        resolutionResults += [.disambiguation(with: disambiguationOptions)]
                        
                    case 1:
                        let recipientMatched = matchingContacts[0].inPerson()
                        resolutionResults += [.success(with: recipientMatched)]
                        
                    case 0:
                        resolutionResults += [.unsupported()]
                    
                    default:
                        break
                }
            }
            
            completion(resolutionResults)
            
        } else {
            // No recipients are provided. We need to prompt for a value.
            completion([INPersonResolutionResult.needsValue()])
        }
    }
        
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Swift.Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        }
        else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // MARK: 2. Confirm
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Swift.Void) {
        
        if UCAccount.shared().hasValidAuthentication {
            completion(INSendMessageIntentResponse(code: .success, userActivity: nil))
        }
        else {
            // Creating our own user activity to include error information.
            let userActivity = NSUserActivity(activityType: String(describing: INSendMessageIntent.self))
            userActivity.userInfo = [NSString(string: "error"):NSString(string: "UserLoggedOut")]
            
            completion(INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity))
        }
    }
    
    // MARK: 3. Handle
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Swift.Void) {
        if intent.recipients != nil && intent.content != nil {
            // Send the message.
            print("sending message")
            let answer = UCAccount.shared().sendMessage(intent.content, toRecipients: intent.recipients)
            print(answer)
            
            let chatViewController = UCChatViewController()
            chatViewController.messageContent = "asd"
            let success = true
            
            
            let utterance = AVSpeechUtterance(string: "William de derde was soevereine Prins van Oranje vanaf de geboorte schot houder van Holland Zeeland Utrecht Gelderland het over nok zo in de Nederlandse Republiek van 1672 en koning van Engeland Ierland en Schotland van 1689 tot aan zijn dood")
            utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL")
            utterance.rate = 0.45
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            
            completion(INSendMessageIntentResponse(code: success ? .failureRequiringAppLaunch : .failure, userActivity: nil))
        }
        else {
            completion(INSendMessageIntentResponse(code: .failure, userActivity: nil))
        }
    }
    
//    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
//        // Implement your application logic to find a message that matches the information in the intent.
//        
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
//        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
//        // Initialize with found message's attributes
//        response.messages = [INMessage(
//            identifier: "identifier",
//            content: "I am so excited about SiriKit!",
//            dateSent: Date(),
//            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
//            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
//            )]
//        completion(response)
//    }

}
