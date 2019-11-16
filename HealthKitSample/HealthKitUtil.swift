//
//  HealthKitUtil.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/15/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import Foundation
import HealthKit


class HealthKitUtil {
  
  private enum HealthkitUtilError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    //1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitUtilError.notAvailableOnDevice)
      return
    }
    
    
    //2. Prepare the data types that will interact with HealthKit
    guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
        let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let allergiesType = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
            let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord) else {
            completion(false, HealthkitUtilError.dataTypeNotAvailable)
            return
    }
    
    //3. Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                    activeEnergy,
                                                    ]
        
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                   bloodType,
                                                   biologicalSex,
                                                   bodyMassIndex,
                                                   height,
                                                   bodyMass,
                                                   allergiesType,
                                                   medicationsType ]
    
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }
  }
    
    class func getAllergyInformation(){
        guard let allergyType = HKObjectType.clinicalType(forIdentifier: .allergyRecord) else {
            fatalError("*** Unable to create the allergy type ***")
        }

        let allergyQuery = HKSampleQuery(sampleType: allergyType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard let actualSamples = samples else {
                // Handle the error here.
                print("*** An error occurred: \(error?.localizedDescription ?? "nil") ***")
                return
            }
            
            let allergySamples = actualSamples as? [HKClinicalRecord]
           
            guard let allergyFHIRRecord = allergySamples?[0].fhirResource else {
                print("No FHIR record found!")
                return
            }
            
            print("HKRecord")
            print(allergyFHIRRecord.data)
            print("END HKRECORD")
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: allergyFHIRRecord.data, options: []) as! NSDictionary
                
                print("BEGIN JSON")
                print(jsonDictionary["id"])
                print(jsonDictionary.value(forKeyPath: "patient.display"))
                print(jsonDictionary.value(forKeyPath: "substance.text"))
                let patientDictionary = jsonDictionary["patient"] as! NSDictionary
                let patientName = patientDictionary["display"] as! String
                print(patientName)
                
                
//                guard let jsonArray = jsonDictionary as? [String: Any] else {
//                      return
//                }
//                print(jsonArray)
//                print("END JSON")
//                let decoder = JSONDecoder()
//                let model = try decoder.decode(AllergyFHIRRecord.self, from:
//                                allergyFHIRRecord.data) //Decode JSON Response Data
//                   print(model)
//
            }
            catch let error {
                print("*** An error occurred while parsing the FHIR data: \(error.localizedDescription) ***")
                // Handle JSON parse errors here.
            }

            
        }

        HKHealthStore().execute(allergyQuery)
    }
}
