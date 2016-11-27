/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's view controller
 */

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        sleep(1)
        exit(0)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //let url = URL(string: "https://smsdoctors.herokuapp.com/alexa2")
        let url = URL(string: "https://smsdoctors.herokuapp.com/alexaengels2")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error ?? " an undefined error occurred while receiving server response")
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let xmlStr:String = String(bytes: data, encoding: String.Encoding.utf8)!
            print(xmlStr)
            
            let utterance = AVSpeechUtterance(string: xmlStr)
            //utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.45
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.delegate = self
            
            synthesizer.speak(utterance)
        }
        task.resume()
    }
    
}
