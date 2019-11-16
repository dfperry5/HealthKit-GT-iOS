//
//  ContentView.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/15/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var fhirSampleURL = "https://www.hl7.org/fhir/patient-example.json";
    
    func authorizeHealthKit() {
        HealthKitUtil.authorizeHealthKit { (authorized, error) in
                 
             guard authorized else {
                   
               let baseMessage = "HealthKit Authorization Failed"
                   
               if let error = error {
                 print("\(baseMessage). Reason: \(error.localizedDescription)")
               } else {
                 print(baseMessage)
               }
                   
               return
             }
                 
             print("HealthKit Successfully Authorized.")
           }
    }
    
   
    
    
    
    
    var body: some View {
        VStack {
            Button( action: { self.authorizeHealthKit()}) {
              Text("Authorize HealthKit")
            }
            Button( action: { HealthKitUtil.getAllergyInformation()}) {
              Text("Get Allergy Data")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
