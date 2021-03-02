//
//  CounterIntentHandler.swift
//  CounterIntent
//
//  Created by Hamas Hassan on 3/1/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Foundation
import Intents
import os.log
import FirebaseAuth
import FirebaseDatabase


class CounterIntentHandler: NSObject, CounterIntentHandling {
    func resolveCounter(for intent: CounterIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let counter = intent.counter else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: counter))
    }
    
    //    func resolveCounter(for intent: CounterIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
    //        guard let counter = intent. else {
    //            completion(INStringResolutionResult.needsValue())
    //            return
    //        }
    //        completion(INStringResolutionResult.success(with: counter))
    //    }
    
    
    
    
    
    
    
    
    func provideCounterOptions(for intent: CounterIntent, with completion: @escaping ([String]?, Error?) -> Void) {
        FirebaseHelper.init()
        FirebaseHelper.getAllCounters(completionHandler: {result in
            os_log(" Handler result %@",result! as CVarArg)
            completion(result!,nil)
        })
        
        //        os_log(" Handler %@",countersName as CVarArg)
        
        
    }
    
    
    
    
    
    //    func confirm(intent: CounterIntent, completion: @escaping (CounterIntentResponse) -> Void) {
    //        let controller = FirebaseHelper()
    //        controller.incrementCounter(id: "1A096611-237A-43E9-A773-21FEF38F5AC8")
    //
    ////        completion(CounterIntentResponse(code: .ready, userActivity: nil))
    //
    //    }
    
    //    var ref = Database.database().reference()
    //
    //       let userID = Auth.auth().currentUser?.uid
    
    func handle(intent: CounterIntent, completion: @escaping (CounterIntentResponse) -> Void) {
        os_log("Fuck you Intent %@",intent.counter as! CVarArg)
        
        FirebaseHelper.findCounterByName(name: intent.counter!, completionHandler:{id in
            os_log(" id result %@",id as CVarArg)
            FirebaseHelper.incrementCounter(id: id )
        })
        
        
        completion(CounterIntentResponse(code: .success, userActivity: nil))
        
    }
    
}
