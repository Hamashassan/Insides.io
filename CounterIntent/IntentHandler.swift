//
//  IntentHandler.swift
//  CounterIntent
//
//  Created by Hamas Hassan on 3/1/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is CounterIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return CounterIntentHandler()
    }
    
    
    
}

