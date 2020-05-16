//
//  CardsProvider.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 30/04/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import Foundation

public protocol CardsProvider {
    func getCards(completion: @escaping ([Card]) -> Void)
}

public class MasterCardCardsProvider: CardsProvider {
    public func getCards(completion: @escaping ([Card]) -> Void) {
        completion([
            Card(number: "123456789", issuer: .masterCard),
            Card(number: "987654321", issuer: .masterCard)
        ])
    }
}

public class CardsProviderImpl: CardsProvider {
    public func getCards(completion: @escaping ([Card]) -> Void) {
        completion([])
    }
}
