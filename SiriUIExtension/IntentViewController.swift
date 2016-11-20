/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The view controller providing a user interface for the intent.
*/

import IntentsUI
import UnicornCore

class IntentViewController: UIViewController, INUIHostedViewControlling, INUIHostedViewSiriProviding {
    
    // MARK: INUIHostedViewControlling
    
    func configure(with interaction: INInteraction!, context: INUIHostedViewContext, completion: ((CGSize) -> Void)!) {
        var size: CGSize
        
        // Check if the interaction describes a SendMessageIntent.
        if interaction.representsSendMessageIntent {
            // If it is, let's set up a view controller.
            let chatViewController = UCChatViewController()
            chatViewController.messageContent = interaction.messageContent

            let contact = UCContact()
            contact.name = interaction.recipientName
            chatViewController.recipient = contact
            
            
            //Retrieve Alexa answer before siri input review to relay it to the user there, currently not implemented
            /*
            //NSLog(message);
            var encoded = interaction.messageContent.replacingOccurrences(of: " ", with: "+")
            //NSLog(encoded);
            // Sending a synchronous message here...
            var request = "https://smsdoctors.herokuapp.com/alexa?q=".appending(encoded)
            //NSString *encoded = [request stringByReplacingOccurancesOfString:@" " withString:@"%20"];
            print(request)
            var url1 = URL(string: request)!
            var urlRequest = URLRequest(url: url1)
            var response: URLResponse? = nil
            var error: Error? = nil
            //var data // = try! NSURLConnection.sendSynchronousRequest(urlRequest, returning: response)!
            let queue: OperationQueue = OperationQueue()
            var check = true;
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler:{ (response: URLResponse!, data: NSData!, error: NSError!) -> Void in
                
                // Handle incoming data like you would in synchronous request
                var reply = NSString(data: data, encoding: NSUTF8StringEncoding)
                f(reply)
                check = false
            })
            
            while(check) {
                //do nothing until Alexa response is ready
            }
            */
            
            switch interaction.intentHandlingStatus {
                case .unspecified, .inProgress, .ready, .failure:
                    chatViewController.isSent = false
                
                case .success, .deferredToApplication:
                    chatViewController.isSent = true
            }
            
            present(chatViewController, animated: false, completion: nil)
            
            size = desiredSize
        }
        else {
            // Otherwise, we'll tell the host to draw us at zero size.
            size = CGSize.zero
        }
        
        completion(size)
    }
    
    
    
    var desiredSize: CGSize {
        return extensionContext!.hostedViewMaximumAllowedSize
    }
    
    var displaysMessage: Bool {
        return true
    }
}
