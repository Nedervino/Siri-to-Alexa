/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The main entry point to the Intents extension.
*/

import Intents

class UCIntentsHandler: INExtension {

    override func handler(for intent: INIntent) -> Any? {
        if intent is INSendMessageIntent || intent is INSearchForMessagesIntent {
            return UCSendMessageIntentHandler()
        }

        return nil
    }
}
