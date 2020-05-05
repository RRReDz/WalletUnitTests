//
//  FakeCardNumberGenerator.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 05/05/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import Foundation

class FakeCardNumberGenerator {
    func generate(for optIssuer: Card.Issuer?) -> String {
        switch optIssuer {
        case .some(let issuer):
            switch issuer {
            case .americanExpress:
                return "3400 0000 0000 009"
            case .masterCard:
                return "5500 0000 0000 0004"
            case .visa:
                return "4111 1111 1111 1111"
            }
        case .none:
            return "1234 5678 9876 5432"
        }
    }
}
