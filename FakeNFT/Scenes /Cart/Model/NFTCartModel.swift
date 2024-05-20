import Foundation

struct NFTCartModel: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}


struct OrdersCartModel: Decodable, Encodable {
    let nfts: [String]
    let id: String
}
