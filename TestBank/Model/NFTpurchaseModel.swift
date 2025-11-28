//
//  NFTpurchaseModel.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import Foundation

struct NFTpurchaseModel: Codable {
    
    let success: Bool
    let nftid: Double?
    
    
    enum CodingKeys: String, CodingKey {
        
        case success
        case nftid = "nft_id"
    
    }
}
