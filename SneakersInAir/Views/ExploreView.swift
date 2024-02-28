//
//  Explore.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 19/02/24.
//

import SwiftUI
import AVFoundation
import Speech

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct ExploreView: View {
    @State var recognizedText: String = ""
    
    
    var body: some View {
        
        VStack{
            SearchBar(recognizedText: $recognizedText)
                .frame(alignment: .leading)
            List {
                ForEach(filteredItems, id: \.self) { item in
                    Text(item)
                }
            }
        }
        
        
    }
    
    private var items = ["Apple", "Shoes","Nike","Sneakers Low", "Adidas"]
    
    private var filteredItems: [String] {
        if recognizedText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(recognizedText) }
        }
    }
}

#Preview {
    ExploreView()
}

// Design della barra di ricerca
struct SearchBar: View {
    @State private var isRecording = false
    @Binding var recognizedText: String
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 50){
                TextField("", text: $recognizedText)
                    .placeholder(when: recognizedText.isEmpty) {
                        Text("Search Sneakers")
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 34)
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
                    .onChange(of: recognizedText, {
                        recognizedText = String(recognizedText.prefix(33))
                    })
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.customorange)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                                .padding(.trailing, 4)
                            Spacer()
                            Button(action: {
                                if isRecording {
                                    stopRecording()
                                } else if !isRecording {
                                    startRecording()
                                }
                            }, label: {
                                HStack{
                                    if(isRecording){
                                        Image(systemName: "mic.fill")
                                            .foregroundColor(.customorange)
                                            .padding(.trailing, 15)
                                            .padding(.leading, 4)
                                    }else{
                                        Image(systemName: "mic")
                                            .foregroundColor(.customorange)
                                            .padding(.trailing, 15)
                                            .padding(.leading, 4)
                                    }
                                }
                                .frame(minWidth: 0, alignment: .trailing)
                            })
                            
                            
                        }
                        
                        
                    )
                
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.customwhite)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                    )
                
            }
            .padding(.leading)
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.customorange)
                    .font(.title2)
            })
            .padding(.trailing, 10)
            .padding(.leading, 5)
            .fixedSize()
        }
        .padding(.bottom)
        
    }
    
    private func startRecording() {
        self.isRecording = true
        
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
        
        
    }
    
    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }
    
}

