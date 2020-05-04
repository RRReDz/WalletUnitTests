//
//  Card.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 30/04/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import Foundation

public struct Card: Equatable {
    let id: UUID = UUID()
    let number: String
    let issuer: Issuer
    
    enum Issuer: String {
        case visa
        case masterCard
        case americanExpress
    }
}
