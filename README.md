# Siri to Alexa

Siri to Alexa allows interacting with Alexa's services and skills directly via Siri, turning your iPhone into an Echo. Furthermore, Google's translate API is used to allow interaction with Alexa for different Siri language settings than English. 

The project consists of a Swift iOS app using SiriKit, a Ruby Server and a collection of Bash scripts. The server and bash scripts are necessary to provide a bridge between Siri's text-based output and Alexa's hard requirement for audio input. Conversions between audio and text are done via a bash library and IBM's Watson speech-to-text service, and language translation is acquired by using Google's translate API. Requires iOS 10