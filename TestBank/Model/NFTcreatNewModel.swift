//
//  NFTcreatNewModel.swift
//  TestBank
//
//  Created by Pavithran P K on 28/11/25.
//

import Foundation

struct NFTcreatNewModel: Decodable {
    let success: Bool
    let nftId: String

    enum CodingKeys: String, CodingKey {
        case success
        case nftId = "nft_id"
    }
}
