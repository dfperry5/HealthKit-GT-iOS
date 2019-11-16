//
//  FHIRModels.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/15/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import Foundation

struct AllergyPatient: Codable {
    var display: String
    var reference: String
}

struct AllergyManifestation: Codable {
    var text: String
}

struct AllergyReaction: Codable {
    var manifestation: [AllergyManifestation]
    var onset: String
    var severity: String
}
struct AllergyCoding: Codable {
    var code: Int64
    var system: String
}
struct AllergySubstance: Codable {
    var coding: [AllergyCoding]
    var text: String
}

struct AllergyFHIRRecord: Codable {
    var id: Int
    var onset: Int
    var patient: AllergyPatient
    var reaction: AllergyReaction
    var recordedDate: String
    var resourceType: String
    var status: String
    var substance: AllergySubstance
    
}
