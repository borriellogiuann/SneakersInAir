//
//  SpeechToTextConverter.swift
//  SneakersInAir
//
//  Created by Davide Formisano on 23/02/24.
//

import Foundation
import SwiftUI
import Speech

struct SpeechToTextConverter: View {
    @State private var isRecording = false
    @State private var recognizedText = ""
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var body: some View {
        VStack {
            Text(recognizedText)
                .padding()
            
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                Text(self.isRecording ? "Stop Recording" : "Start Recording")
            }
            .padding()
        }
    }
    
    
    private func startRecording() {
        self.recognizedText = ""
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup error: \(error)")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = self.recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isRecording = false
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine start error: \(error)")
        }
        
        self.isRecording = true
    }
    
    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechToTextConverter()
    }
}
