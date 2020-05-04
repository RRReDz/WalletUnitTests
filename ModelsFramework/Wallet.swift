//
//  Wallet.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 30/04/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import Foundation

public class Wallet {
    private(set) var cards: [Card]
    private var cardsProvider: CardsProvider?
    
    init(cards: [Card] = []) {
        self.cards = cards
    }
    
    convenience init(cardsProvider: CardsProvider) {
        self.init()
        self.cardsProvider = cardsProvider
    }
    
    @discardableResult
    public func add(_ cards: [Card]) -> Self {
        self.cards.append(contentsOf: cards)
        return self
    }
    
    @discardableResult
    public func set(_ cardsProvider: CardsProvider) -> Self {
        self.cardsProvider = cardsProvider
        return self
    }
    
    public func loadCards(completion: @escaping () -> Void) {
        guard let cardsProvider = cardsProvider else {
            return
        }
        
        cardsProvider.getCards { cards in
            self.add(cards)
            completion()
        }
    }
}
