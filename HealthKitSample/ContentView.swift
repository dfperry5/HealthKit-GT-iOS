//
//  ContentView.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/15/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    @State var retrievedFhirData = false
    @State var allergy = ""
    @State var patientName = ""
    
    
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
    
    func getAllergyInformation() {
        HealthKitUtil.getAllergyInformation() { (jsonResponse) in
            
            self.allergy = jsonResponse.value(forKeyPath: "substance.text") as! String
            self.patientName = jsonResponse.value(forKeyPath: "patient.display") as! String
            self.retrievedFhirData = true
            
        }
       }
    
    var body: some View {
            
        VStack {
            Text("CS6440 - Health Kit Sample")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.red)
            Spacer().frame(height: 50)
            Button( action: { self.authorizeHealthKit()}) {
              Text("Authorize HealthKit")
            }
            Spacer().frame(height: 20)
            Button( action: { self.getAllergyInformation()}) {
              Text("Get Allergy Information")
            }
            Spacer().frame(height: 20)
            if self.retrievedFhirData {
                Text("\(patientName) is allergic to \(allergy)")
                    .foregroundColor(Color.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
