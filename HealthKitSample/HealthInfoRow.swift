//
//  HealthInfoRow.swift
//  HealthKitSample
//
//  Created by Dylan Perry on 11/16/19.
//  Copyright © 2019 Dylan Perry. All rights reserved.
//

import SwiftUI

struct HealthInfoRow: View {
    var medicalType: String

    
    var body: some View {
        Text(medicalType)
    }
}

struct HealthInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthInfoRow(medicalType: "Allergies")
    }
}
