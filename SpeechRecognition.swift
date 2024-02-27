//
//  SpeechRecognition.swift
//  SneakersInAir
//
//  Created by Davide Formisano on 20/02/24.
//

import AVFoundation
import Speech

func requestionPermission (completion: @escaping (String) -> Void){ SFSpeechRecognizer.requestAuthorization { authStatus in
    if authStatus == .authorized{
        do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                        
                let recognizer = SFSpeechRecognizer()
                let request = SFSpeechAudioBufferRecognitionRequest()
                let recognitionTask = recognizer?.recognitionTask(with: request) { result, error in
                guard let result = result else {
                        print("Recognition error: \(error.debugDescription)")
                        return
                            }
                            if result.isFinal {
                                completion(result.bestTranscription.formattedString)
                            }
                        }
                        
                        let audioEngine = AVAudioEngine()
                        let inputNode = audioEngine.inputNode
                        let recordingFormat = inputNode.outputFormat(forBus: 0)
                        
                        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                            request.append(buffer)
                        }
                        
                        audioEngine.prepare()
                        try audioEngine.start()
                    } catch {
                        print("Error setting up audio session: \(error.localizedDescription)")
                    }
                } else {
                    print("Speech recognition authorization failed")
                    completion("Authorization failed")
                }
    }
}

