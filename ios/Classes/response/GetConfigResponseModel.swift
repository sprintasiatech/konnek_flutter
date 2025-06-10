//import Foundation
//
//struct GetConfigResponseModel: Codable {
//    let data: DataGetConfig?
//    let meta: MetaGetConfig?
//}
//
//struct DataGetConfig: Codable {
//    let preview: String?
//    let backgroundStatus: String?
//    let widgetIcon: String?
//    let companyId: String?
//    let headerTextColor: String?
//    let textButtonColor: String?
//    let avatarImage: String?
//    let textButton: String?
//    let headerBackgroundColor: String?
//    let buttonColor: String?
//    let greetingMessage: String?
//    let background: String?
//    let avatarName: String?
//    let status: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case preview
//        case backgroundStatus = "background_status"
//        case widgetIcon = "widget_icon"
//        case companyId = "company_id"
//        case headerTextColor = "header_text_color"
//        case textButtonColor = "text_button_color"
//        case avatarImage = "avatar_image"
//        case textButton = "text_button"
//        case headerBackgroundColor = "header_background_color"
//        case buttonColor = "button_color"
//        case greetingMessage = "greeting_message"
//        case background
//        case avatarName = "avatar_name"
//        case status
//    }
//}
//
//struct MetaGetConfig: Codable {
//    let logId: String?
//    let code: Int?
//    let message: String?
//    let errors: AnyCodable?  // We'll handle dynamic typing here
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
