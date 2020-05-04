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
