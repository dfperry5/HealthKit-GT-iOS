//
//  HealthInfoDetailView.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/16/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import SwiftUI
import HealthKit


struct HealthInfoDetailView: View {
    var medicalType: String
    let stringToHKitObject: NSDictionary = [
        "Allergies" :  HKObjectType.clinicalType(forIdentifier: .allergyRecord),
        "BMI" : HKObjectType.quantityType(forIdentifier: .bodyMassIndex)
    ]
    
    @State var retrievedFhirData = false
    @State var displayText = ""
    
    func getMedicalInfromation(){
        HealthKitUtil.getInformation(sampleType: self.stringToHKitObject.value(forKey: self.medicalType) as! HKSampleType) { (jsonResponse) in
                
                print(jsonResponse)
                
                let allergy = jsonResponse.value(forKeyPath: "substance.text") as! String
                
                let patientName = jsonResponse.value(forKeyPath: "patient.display") as! String
                
                self.displayText = "\(patientName) is allergic to \(allergy)"
                
                self.retrievedFhirData = true
            
            }
    }
    
    var body: some View {
        VStack {
            Text(medicalType).font(.headline).onAppear(perform: self.getMedicalInfromation)
             Spacer().frame(height: 20)
            if self.retrievedFhirData {
                Text(self.displayText)
                    .foregroundColor(Color.green)
            }
        }
    }
}

struct HealthInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HealthInfoDetailView(medicalType: "Allergies")
    }
}
