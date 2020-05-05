//
//  WalletCardsSet.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 05/05/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import Foundation

enum WalletCardsSet {
    case noCards
    case allDifferent
    case twoDifferent
    case threeAllDifferent
    case threeWithTwoEquals
    case allEquals(number: Int, issuer: Card.Issuer)
    
    var cards: [Card] {
        let fakeCardNumberGenerator = FakeCardNumberGenerator()
        switch self {
        case .noCards:
            return []
        case .twoDifferent:
            return [
                Card(number: fakeCardNumberGenerator.generate(for: .visa), issuer: .visa),
                Card(number: fakeCardNumberGenerator.generate(for: .masterCard), issuer: .masterCard)
            ]
        case .threeAllDifferent:
            return [
                Card(number: fakeCardNumberGenerator.generate(for: .visa), issuer: .visa),
                Card(number: fakeCardNumberGenerator.generate(for: .masterCard), issuer: .masterCard),
                Card(number: fakeCardNumberGenerator.generate(for: .americanExpress), issuer: .americanExpress)
            ]
        case .allDifferent:
            return [
                Card(number: "1", issuer: .visa),
                Card(number: "2", issuer: .masterCard),
                Card(number: "3", issuer: .masterCard),
                Card(number: "4", issuer: .americanExpress),
                Card(number: "5", issuer: .masterCard),
                Card(number: "6", issuer: .visa)
            ]
        case .threeWithTwoEquals:
            return [
                Card(number: fakeCardNumberGenerator.generate(for: .visa), issuer: .visa),
                Card(number: fakeCardNumberGenerator.generate(for: .masterCard), issuer: .masterCard),
                Card(number: fakeCardNumberGenerator.generate(for: .masterCard), issuer: .masterCard)
            ]
        case .allEquals(let numberOfCards, let issuer):
            let cardNumber: String = fakeCardNumberGenerator.generate(for: issuer)
            let card: Card = Card(number: cardNumber, issuer: issuer)
            return [Card].init(repeating: card, count: numberOfCards)
        }
    }
}
