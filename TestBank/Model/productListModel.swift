//
//  productListModel.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import Foundation



struct ProductListResponseWrapper: Codable {
    let items: [ProductListResponse]
}

struct ProductListResponse: Codable {
    let id: String?
    let title: String?
    let description: String?
    let price: Double?
    let currency: String?
    let owner: String?
    let createdBy: String?
    let imageUrl: String?
    let available: Bool?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case price
        case currency
        case owner
        case createdBy
        case imageUrl
        case available
        case createdAt
        case updatedAt
        case v = "__v"
        
    }
}

struct MyNFTListModel: Codable {
    let items: [MyNFTListDataModel]
}

struct MyNFTListDataModel: Codable {
    let id: String?
    let title: String?
    let description: String?
    let currency: String?
    var price: Double?
    let owner: String?
    let createdBy: String?
    let imageUrl: String?
    let available: Bool?
    let v: Int?
    let createdAt: String?
    let updatedAt: String?
    let purchasedAt: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case currency
        case price
        case owner
        case createdBy
        case imageUrl
        case available
        case v = "__v"
        case createdAt
        case updatedAt
        case purchasedAt
        
    }
}
nonisolated struct ServerError: Decodable {
    let error: String
}
