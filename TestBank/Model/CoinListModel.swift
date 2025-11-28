//
//  CoinListModel.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import Foundation

struct CoinListModel: Codable {
    let coins: [CoinListDataModel]
}

struct CoinListDataModel: Codable {
    
    let symbol: String?
    let balance: Double?
    
    
    enum CodingKeys: String, CodingKey {
        
        case symbol
        case balance
    
    }
}
