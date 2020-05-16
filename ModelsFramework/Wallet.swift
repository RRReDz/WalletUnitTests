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
    public func add(_ card: Card) -> Self {
        return self.add([card])
    }
    
    @discardableResult
    public func remove(_ card: Card) -> Bool {
        if let indexToRemove = self.cards.firstIndex(of: card) {
            self.cards.remove(at: indexToRemove)
            return true
        } else {
            return false
        }
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

//Bad
public class WalletWrong {
    private var cardsProvider: CardsProvider
    
    init() {
        /* Error! MasterCardCardsProvider is a dependency and it's not injected */
        cardsProvider = MasterCardCardsProvider()
    }
    
    func getCardsFromNewProvider(completion: @escaping ([Card]) -> Void) {
        /* Error! MasterCardCardsProvider is a dependency and it's not injected */
        cardsProvider = MasterCardCardsProvider()
        cardsProvider.getCards {
            completion($0)
        }
    }
}

//Good
public class WalletGood {
    private var cardsProvider: CardsProvider
    
    init(cardsProvider: CardsProvider) {
        self.cardsProvider = cardsProvider
    }
    
    func getCardsFromNewProvider(cardsProvider: CardsProvider, completion: @escaping ([Card]) -> Void) {
        self.cardsProvider = cardsProvider
        cardsProvider.getCards {
            completion($0)
        }
    }
}

public class WalletDependencyImpl {
    private var cardsProvider: CardsProviderImpl
    
    init(cardsProvider: CardsProviderImpl) {
        self.cardsProvider = cardsProvider
    }
}


