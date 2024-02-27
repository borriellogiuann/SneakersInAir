//
//  VisionAIModel.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import Foundation

struct Response: Codable{
    var id: String
    var choices: [ResponseMessage]
    
    struct ResponseMessage: Codable{
        var index: Int
        var message: Mex
    }

    struct Mex: Codable{
        var role: String
        var content: String
    }
}


/*
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "gpt-3.5-turbo-0613",
  "system_fingerprint": "fp_44709d6fcb",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "content": "\n\nHello there, how may I assist you today?",
    },
    "logprobs": null,
    "finish_reason": "stop"
  }],
  "usage": {
    "prompt_tokens": 9,
    "completion_tokens": 12,
    "total_tokens": 21
  }
}
*/
