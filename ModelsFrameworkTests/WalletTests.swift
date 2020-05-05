//
//  WalletTests.swift
//  ModelsFrameworkTests
//
//  Created by Rossi Riccardo on 30/04/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import XCTest
@testable import ModelsFramework

class WalletTests: XCTestCase {
    var sut: Wallet!
    
    private func feedSutWithStaticCardsSet(_ cardsSet: WalletCardsSet = .threeAllDifferent) -> [Card] {
        let cards: [Card] = cardsSet.cards
        sut.add(cards)
        return cards
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sut = Wallet()
    }
    
    func test_creatingWalletWithThreeCards_startingWithNoCards_shouldHaveTheThreeAddedCards() {
        //Given
        let cards: [Card] = WalletCardsSet.threeWithTwoEquals.cards
        
        //When
        let sut = Wallet(cards: cards)
        
        //Then
        XCTAssertEqual(sut.cards, cards)
    }
    
    // Stub (Dependency injection with a simple native data structure (array of cards))
    func test_addingNCards_withNoCards_shouldHaveTheNAddedCards() {
        //Given
        let sut: Wallet = Wallet()
        /* This is the simplest example of stub */
        let cards: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa),
            Card(number: "5500 0000 0000 0004", issuer: .masterCard),
            Card(number: "3400 0000 0000 009",  issuer: .americanExpress)
        ]
        
        //When
        sut.add(cards)
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    func test_addingNCards_withNoCards_shouldHaveTheNAddedCards_2() {
        //Given
        let sut: Wallet = Wallet()
        /* This is the simplest example of stub */
        let cards: [Card] = WalletCardsSet.threeAllDifferent.cards
        
        //When
        sut.add(cards)
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    func test_addingNCards_withNoCards_shouldHaveTheNAddedCards_3() {
        //Given/When
        let cards = self.feedSutWithStaticCardsSet()
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    //Stub (Dependency injection with object that is conform to a protocol that is asked from the sut)
    func test_loadingNCardsThroughProvider_withNoCards_shouldHaveTheNLoadedCards() {
        //Given
        class CardsProviderStub: CardsProvider {
            let cards: [Card]
            
            init(cards: [Card]) {
                self.cards = cards
            }
            
            func getCards(completion: ([Card]) -> Void) {
                completion(cards)
            }
        }
        
        /* Passing data to stub that is going to give to wallet later */
        let cards: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa),
            Card(number: "5500 0000 0000 0004", issuer: .masterCard),
            Card(number: "3400 0000 0000 009",  issuer: .americanExpress)
        ]
        let cardsProviderStub: CardsProviderStub = CardsProviderStub(cards: cards)
        let sut: Wallet = Wallet(
            cardsProvider: cardsProviderStub
        )
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    func test_loadingNCardsThroughProvider_withNoCards_shouldHaveTheNLoadedCards_2() {
        //Given
        class CardsProviderStub: CardsProvider {
            let cards: [Card]
            
            init(cards: [Card]) {
                self.cards = cards
            }
            
            func getCards(completion: ([Card]) -> Void) {
                completion(cards)
            }
        }
        
        /* Passing data to stub that is going to give to wallet later */
        let cards: [Card] = WalletCardsSet.threeAllDifferent.cards
        let cardsProviderStub: CardsProviderStub = CardsProviderStub(cards: cards)
        let sut: Wallet = Wallet(
            cardsProvider: cardsProviderStub
        )
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    func test_loadingNCardsThroughProvider_withNoCards_shouldHaveTheNLoadedCards_3() {
        //Given
        class CardsProviderStub: CardsProvider {
            let cards: [Card]
            
            init(cards: [Card]) {
                self.cards = cards
            }
            
            func getCards(completion: ([Card]) -> Void) {
                completion(cards)
            }
        }
        let cards: [Card] = WalletCardsSet.allEquals(number: 2, issuer: .visa).cards
        let cardsProviderStub: CardsProviderStub = CardsProviderStub(cards: cards)
        sut.set(cardsProviderStub)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(sut.cards.count, cards.count, "cards")
        XCTAssertEqual(sut.cards, cards, "cards")
    }
    
    //Mock (Dependency injection with object that is conform to a protocol that is asked from the sut)
    func test_loadingCards_alreadyAskedForCardsYTimes_cardsHaveBeenAskedYPlusOneTimes() {
        //Given
        class CardsProviderMock: CardsProvider {
            var timesCardsHaveBeenAsked = 0
            
            func getCards(completion: ([Card]) -> Void) {
                timesCardsHaveBeenAsked += 1
                completion([])
            }
        }
        let cardsProviderMock: CardsProviderMock = CardsProviderMock()
        let timesCardsHaveBeenAskedBeforeTest = cardsProviderMock.timesCardsHaveBeenAsked
        let sut: Wallet = Wallet(
            cardsProvider: cardsProviderMock
        )
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(cardsProviderMock.timesCardsHaveBeenAsked, timesCardsHaveBeenAskedBeforeTest + 1)
    }
    
    /* MARK: Good Unit Test Rules */
    /* MARK: Rule 1
     * Unit tests name’s must compliant to the standard: test_[action]_[initialState]_[expectedFinalState/Behavior].
     */
    
    //Bad
    func testAddCard() {
        // Your test code...
    }
    
    //Bad
    func test_ADDINGONECARD() {
        // Your test code...
    }
    
    //Bad
    func test_addingOneCardInThisParticularCase() {
        // Your test code...
    }
    
    //Good
    func test_addingThreeCards_withNoCards_shouldHaveTheThreeAddedCards() {
        // Your test code...
    }
    
    //Good
    func test_addingOneCard_withThreeCards_shouldHaveFourCards() {
        // Your test code...
    }
    
    /* MARK: Rule 2
    * Structure the test following the standard Given-When-Then
    */
    
    //Bad
    func test_addingOneCard_withNoCards_shouldHaveOneCard_Rule2_Bad() {
        XCTAssertEqual(Wallet().add([Card(number: "4111 1111 1111 1111", issuer: .visa)]).cards.count, 1)
    }
    
    //Good
    func test_addingOneCard_withNoCards_shouldHaveOneCard_Rule2_Good() {
        //Given
        let sut: Wallet = Wallet()
        let cards: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa)
        ]
        
        //When
        sut.add(cards)
        
        //Then
        XCTAssertEqual(sut.cards.count, 1, "cards")
    }
    
    
    /* MARK: Rule 3
    * Unit tests must be stateless.
    */
    
    static var sharedSut: Wallet = Wallet()
    
    // MARK: Example 1
    
    //Bad
    func test_addingTwoCards_withNoCards_shouldHaveTwoCards_Rule3_Example1_Bad_1() {
        //Given
        let cards: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa),
            Card(number: "5500 0000 0000 0004", issuer: .masterCard)
        ]
        
        //When
        WalletTests.sharedSut.add(cards)
        
        //Then
        XCTAssertEqual(WalletTests.sharedSut.cards.count, 2, "cards")
    }
    
    func test_addingOneCard_withFiveCards_shouldHaveSixCards_Rule3_Example1_Bad_2() {
        //Given
        WalletTests.sharedSut.add(WalletCardsSet.allEquals(number: 5, issuer: .visa).cards)
        let cardsToAdd: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa)
        ]
        
        //When
        WalletTests.sharedSut.add(cardsToAdd)
        
        //Then
        XCTAssertEqual(WalletTests.sharedSut.cards.count, 6, "cards")
    }
    
    /* MARK: Rule 4
     * Don’t use if-statements.
     */
    
    //Bad
    func test_addingOneCard_withUndefinedCards_shouldHaveOneOrMoreCards_Rule4_Bad() {
        //Given
        let sut: Wallet = Wallet()
        let cards: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa)
        ]
        
        //When
        if !cards.isEmpty { // <- Error! This makes test code dynamic
            sut.add(cards)
        }
        
        //Then
        // Error! This could be done with only an assertion instead of making code dynamic!
        if !sut.cards.isEmpty {
            XCTAssert(true)
        } else {
            XCTFail("Wallet doesn't contain cards")
        }
    }
    
    func test_addingOneCard_withUndefinedCards_shouldHaveOneOrMoreCards_Rule4_Good() {
        //Given
        let undefinedPreloadedCards: [Card] = WalletCardsSet.allEquals(number: 4, issuer: .visa).cards
        let sut: Wallet = Wallet(cards: undefinedPreloadedCards)
        let cardsToAdd: [Card] = [
            Card(number: "4111 1111 1111 1111", issuer: .visa)
        ]
        
        //When
        sut.add(cardsToAdd)
        
        //Then
        XCTAssertTrue(!sut.cards.isEmpty, "Wallet doesn't contain cards")
        // or... XCTAssertGreaterThan(sut.cards.count, 0, "cards")
    }
    
    /* MARK: Rule 5
     * Do not instantiate other non-testdouble dependencies besides the sut (otherwise that will be an integration test instead of a unit test).
     * Simple classes or enums used as data models, like Card in this case, or Data Types like Strings, Integers etc. are allowed.
     */
    
    class VisaCardProvider: CardsProvider {
        /* Fake data */
        private static let parsedCard: [Card] = []
        
        private func parseDataIntoCards(data: Data) -> [Card] {
            return []
        }
        /* End of fake data */
        
        func getCards(completion: @escaping ([Card]) -> Void) {
            
            /* Put this here because URLSession call won't answer without a valid url */
            completion([])
            return
            
            let apiUrl: URL = URL(string: "http://api.wallet.com/.../visa/card")!
            URLSession(configuration: .default).dataTask(with: apiUrl) { data, response, error in
                if let data = data {
                    // Parsing data into array of cards (real production code)
                    completion(self.parseDataIntoCards(data: data))
                } else {
                    //Error occurred
                }
            }
        }
    }
    
    //Bad
    func test_loadingOneVisaCardThroughProvider_withThreeAmexCards_shouldNotHaveMasterCardCards_Rule5_Bad() {
        //Given
        let cardsProvider: VisaCardProvider = VisaCardProvider() // <- Error! Real production object dependency, can't have control over the output, probably is going to invalidate "Fast" and "Repeatable" properties of FIRST paradigm. Should be used a test double instead.
        let sut: Wallet = Wallet(cards: WalletCardsSet.allEquals(number: 3, issuer: .americanExpress).cards)
        sut.set(cardsProvider)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertTrue(!sut.cards.contains{ $0.issuer == .masterCard }, "Wallet contains a masterCard card!")
    }
    
    //Good
    func test_loadingOneVisaCardThroughProvider_withThreeAmexCards_shouldNotHaveMasterCardCards_Rule5_Good() {
        //Given
        class VisaCardProviderStub: CardsProvider {
            func getCards(completion: @escaping ([Card]) -> Void) {
                completion(WalletCardsSet.allEquals(number: 1, issuer: .visa).cards)
            }
        }
        let cardsProvider = VisaCardProviderStub()
        let sut = Wallet(cards: WalletCardsSet.allEquals(number: 3, issuer: .americanExpress).cards)
        sut.set(cardsProvider)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Expect to load cards")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertTrue(!sut.cards.contains{ $0.issuer == .masterCard }, "Wallet contains a masterCard card!")
    }
    
    /* MARK: Rule 6
     * Make your test failure messages clear.
     */
    
    //Bad
    func test_removingOneExistingCard_startingWithDifferentCards_shouldNotHaveTheCardToRemove_Rule6_Bad() {
        //Given
        let preloadedCards: [Card] = WalletCardsSet.allDifferent.cards
        let cardToRemove: Card = preloadedCards.last!
        let sut = Wallet(cards: preloadedCards)
        
        //When
        sut.remove(cardToRemove)
        
        //Then
        XCTAssertTrue(!sut.cards.contains(cardToRemove))
    }
    
    //Good
    func test_removingOneExistingCard_startingWithDifferentCards_shouldNotHaveTheCardToRemove_Rule6_Good() {
        //Given
        let preloadedCards: [Card] = WalletCardsSet.allDifferent.cards
        let cardToRemove: Card = preloadedCards.last!
        let sut = Wallet(cards: preloadedCards)
        
        //When
        sut.remove(cardToRemove)
        
        //Then
        XCTAssertTrue(!sut.cards.contains(cardToRemove), "The wallet still contains the card that should have been removed!")
    }
    
    /* MARK: Rule 7
     * Make use of assertions only to test what is asked to test.
     */
    
    //Bad (following the naming)
    func test_removingFirstAddedCard_startingWithTwoDifferentCards_shouldHaveOneCard_Rule7_Bad() {
        //Given
        let preloadedCards: [Card] = WalletCardsSet.twoDifferent.cards
        let cardToRemove: Card = preloadedCards.first!
        let sut = Wallet(cards: preloadedCards)
        
        //When
        sut.remove(cardToRemove)
        
        //Then
        //Problem here! This assertion is syntatically correct but not necessary here since the expected final state/behavior is only that the wallet should have one card, so is not conform to what asked from the test. These would have been correct if the the final state was something like "shouldHavePreloadedCardsMinusTheFirstCard" or "correctlyRemovedOnlyTheFirstCard"
        let resultingCards: [Card] = [Card](preloadedCards.dropFirst())
        XCTAssertEqual(sut.cards, resultingCards, "The wallet is not made by the preloaded cards minus the first card")
        // or... XCTAssertTrue(!sut.cards.contains(cardToRemove), "The wallet still contains the card that should have been removed")
    }
    
    //Good (following the naming)
    func test_removingFirstAddedCard_startingWithTwoDifferentCards_shouldHaveOneCard_Rule7_Good() {
        //Given
        let preloadedCards: [Card] = WalletCardsSet.twoDifferent.cards
        let cardToRemove: Card = preloadedCards.first!
        let sut = Wallet(cards: preloadedCards)
        
        //When
        sut.remove(cardToRemove)
        
        //Then
        XCTAssertEqual(sut.cards.count, 1)
    }
    
    /* MARK: Rule 8
     * Avoid use of variables defined at test class level without creating/destroying them in “setUp”/”tearDown” methods.
     */
    
    //Bad
    
    /*
        Here should be visible something like:
        private var sut: Wallet = Wallet()
    */
    
    func test_addingOneCard_startingWithNoCards_shouldHaveOneCard_Rule8_Bad() {
        //Given
        let cards: [Card] = [
            Card(number: "5500 0000 0000 0004", issuer: .masterCard)
        ]
        
        //When
        sut.add(cards)
        
        //Then
        XCTAssertEqual(sut.cards.count, 1)
    }
    
    //Good
    
    /*
        Here should be visible something like:
        private var sut: Wallet!
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
            self.sut = Wallet()
        }
     */
    
    func test_addingOneCard_stringWithNoCards_shouldHaveOneCard_Rule8_Good() {
        //Given
        let cards: [Card] = [
            Card(number: "5500 0000 0000 0004", issuer: .masterCard)
        ]
        
        //When
        sut.add(cards)
        
        //Then
        XCTAssertEqual(sut.cards.count, 1)
    }
    
    /*
         override func tearDown() {
             // Put teardown code here. This method is called after the invocation of each test method in the class.
             self.sut = nil
         }
     */
    
    /* MARK: Rule 9
     * Don’t repeat yourself/duplicate code
     */
    
    //Bad
    func test_addingOneCardVisa1234_startingWithNoCards_visa1234ShouldBeCorrectlyAddedAsLastCard_Rule9_Bad1() {
        //Given
        let cardVisa1234ToAdd = Card(number: "1234", issuer: .visa)
        let sut = Wallet()
        
        //When
        sut.add(cardVisa1234ToAdd)
        
        //Then
        XCTAssertNotNil(sut.cards.last, "The card has not been added to the wallet")
        XCTAssertEqual(sut.cards.last?.number, "1234")
        XCTAssertEqual(sut.cards.last?.issuer, .visa)
    }
    
    func test_addingOneCardAmex5678_startingWithNoCards_amex5678ShouldBeCorrectlyAddedAsLastCard_Rule9_Bad2() {
        //Given
        let cardAmex5678ToAdd = Card(number: "5678", issuer: .americanExpress)
        let sut = Wallet()
        
        //When
        sut.add(cardAmex5678ToAdd)
        
        //Then
        XCTAssertNotNil(sut.cards.last, "The card has not been added to the wallet")
        XCTAssertEqual(sut.cards.last?.number, "5678")
        XCTAssertEqual(sut.cards.last?.issuer, .americanExpress)
    }
    
    //Good
    static func assertLastCard(of wallet: Wallet, is card: Card, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(wallet.cards.last, "The card has not been added to the wallet", file: file, line: line)
        XCTAssertEqual(wallet.cards.last?.number, card.number, "card number", file: file, line: line)
        XCTAssertEqual(wallet.cards.last?.issuer, card.issuer, "card issuer", file: file, line: line)
    }
    
    func test_addingOneCardVisa1234_startingWithNoCards_visa1234ShouldBeCorrectlyAddedAsLastCard_Rule9_Good1() {
        //Given
        let cardVisa1234ToAdd = Card(number: "1234", issuer: .visa)
        let sut = Wallet()
        
        //When
        sut.add(cardVisa1234ToAdd)
        
        //Then
        WalletTests.assertLastCard(of: sut, is: cardVisa1234ToAdd)
    }
    
    func test_addingOneCardAmex5678_startingWithNoCards_amex5678ShouldBeCorrectlyAddedAsLastCard_Rule9_Good2() {
        //Given
        let cardAmex5678ToAdd = Card(number: "5678", issuer: .americanExpress)
        let sut = Wallet()
        
        //When
        sut.add(cardAmex5678ToAdd)
        
        //Then
        WalletTests.assertLastCard(of: sut, is: cardAmex5678ToAdd)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.sut = nil
    }
    
    #warning("TODO")
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
