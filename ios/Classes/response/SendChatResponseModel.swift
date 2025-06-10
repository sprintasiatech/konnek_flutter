//import Foundation
//
//// MARK: - Root Response
//struct SendChatResponseModel: Codable {
//    let data: DataSendChat?
//    let meta: MetaSendChat?
//}
//
//// MARK: - Data Section
//struct DataSendChat: Codable {
//    let expire: String?
//    let sessionId: String?
//    let tid: String?
//    let token: String?
//
//    enum CodingKeys: String, CodingKey {
//        case expire
//        case sessionId = "session_id"
//        case tid
//        case token
//    }
//}
//
//// MARK: - Meta Section
//struct MetaSendChat: Codable {
//    let logId: String?
//    let code: Int?
//    let message: String?
//    let errors: AnyCodable?
//    let status: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case logId = "log_id"
//        case code
//        case message
//        case errors
//        case status
//    }
//}
//
//// MARK: - AnyCodable (for dynamic type like errors)
//struct AnyCodable: Codable {}
