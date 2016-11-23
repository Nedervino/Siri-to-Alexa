/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The application's view controller
*/

import UIKit
import SpeechKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        sleep(1)
        exit(0)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let url = URL(string: "https://smsdoctors.herokuapp.com/alexaengels2")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            let json = try JSONSerialization.jsonObject(with: data, options:
//                JSONSerialization.ReadingOptions.mutableContainers)
//            print(data)
            let xmlStr:String = String(bytes: data, encoding: String.Encoding.utf8)!
            print(xmlStr)
            
            let utterance = AVSpeechUtterance(string: xmlStr)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.45
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.delegate = self

            synthesizer.speak(utterance)
            

//            sleep(10)
//            exit(0)
        }
        task.resume()
        
//        let utterance = AVSpeechUtterance(string: "William de derde was soevereine Prins van Oranje vanaf de geboorte schot houder van Holland Zeeland Utrecht Gelderland het over nok zo in de Nederlandse Republiek van 1672 en koning van Engeland Ierland en Schotland van 1689 tot aan zijn dood")
//        utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL")
//        utterance.rate = 0.45
//        
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
//
        
//        let serverUrl = URL(fileURLWithPath: "nmsps://NMDPTRIAL_abcmaster8_hotmail_com20161119082832@sslsandbox-nmdp.nuancemobility.net:443")
//        let appKey = "93544fe154bcef7b0097e1967351e5da1ffee8825a1edefd795078d1426163d6b6b2b70a6ea6856e3e6604b1b7e98bd7e773594191373e0b87b7dcca183fa0ce"
//        let session = SKSession(url: serverUrl, appToken: appKey)
//        print(session);
//        let textToSpeak = "Hello World";
//        
//        // use this to specify a voice (language will be determined based on the voice)
//
//        let transaction = session?.speak(textToSpeak, withVoice: "Samantha", options: [:], delegate: self)
//        print(transaction);
//        
//        // Handle the text field’s user input through delegate callbacks.
//        print("hoi")
        
    }

}


