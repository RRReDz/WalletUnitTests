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
    
    enum WalletCardsSet {
        case noCards
        case threeCardsAllTypes
        case threeCardsTwoSameIssuer
        case allEqualsCards(number: Int, issuer: Card.Issuer)
        case custom(cards: [Card])
        
        var cards: [Card] {
            switch self {
            case .noCards:
                return []
            case .threeCardsAllTypes:
                return [
                    Card(number: UUID().description, issuer: .visa),
                    Card(number: UUID().description, issuer: .masterCard),
                    Card(number: UUID().description, issuer: .americanExpress)
                ]
            case .threeCardsTwoSameIssuer:
                return [
                    Card(number: UUID().description, issuer: .visa),
                    Card(number: UUID().description, issuer: .masterCard),
                    Card(number: UUID().description, issuer: .masterCard)
                ]
            case .allEqualsCards(let numberOfCards, let issuer):
                let cardNumber: String = UUID().description
                let card: Card = Card(number: cardNumber, issuer: issuer)
                return [Card].init(repeating: card, count: numberOfCards)
            case .custom(let cards):
                return cards
            }
        }
    }
    
    private func feedSutWithStaticCardsSet(_ cardsSet: WalletCardsSet = .threeCardsAllTypes) -> [Card] {
        let cards: [Card] = cardsSet.cards
        sut.add(cards)
        return cards
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sut = Wallet()
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
        let cards: [Card] = WalletCardsSet.threeCardsAllTypes.cards
        
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
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
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
        let cards: [Card] = WalletCardsSet.threeCardsAllTypes.cards
        let cardsProviderStub: CardsProviderStub = CardsProviderStub(cards: cards)
        let sut: Wallet = Wallet(
            cardsProvider: cardsProviderStub
        )
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
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
        let cards: [Card] = WalletCardsSet.allEqualsCards(number: 2, issuer: .visa).cards
        let cardsProviderStub: CardsProviderStub = CardsProviderStub(cards: cards)
        sut.set(cardsProviderStub)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
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
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
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
        WalletTests.sharedSut.add(WalletCardsSet.allEqualsCards(number: 5, issuer: .visa).cards)
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
        let undefinedPreloadedCards: [Card] = WalletCardsSet.allEqualsCards(number: 4, issuer: .visa).cards
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
        let sut: Wallet = Wallet(cards: WalletCardsSet.allEqualsCards(number: 3, issuer: .americanExpress).cards)
        sut.set(cardsProvider)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
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
                completion(WalletCardsSet.allEqualsCards(number: 1, issuer: .visa).cards)
            }
        }
        let cardsProvider = VisaCardProviderStub()
        let sut = Wallet(cards: WalletCardsSet.allEqualsCards(number: 3, issuer: .americanExpress).cards)
        sut.set(cardsProvider)
        let loadingExpectation: XCTestExpectation = XCTestExpectation(description: "Cards are now loaded")
        
        //When
        sut.loadCards {
            loadingExpectation.fulfill()
        }
        
        wait(for: [loadingExpectation], timeout: 5.0)
        
        //Then
        XCTAssertTrue(!sut.cards.contains{ $0.issuer == .masterCard }, "Wallet contains a masterCard card!")
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
