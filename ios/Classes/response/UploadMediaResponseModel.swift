//struct UploadMediaResponseModel: Codable {
//    let data: DataUploadMedia?
//    let meta: MetaUploadMedia?
//}
//
//struct DataUploadMedia: Codable {
//    let replyToken: String?
//    let agent: AgentUploadMedia?
//    let companyId: String?
//    let session: SessionUploadMedia?
//    let providerMessageId: String?
//    let messageId: String?
//    let channelCode: String?
//    let message: MessageUploadMedia?
//    let error: AnyCodable?
//    let csat: AnyCodable?
//    let replyId: String?
//    let republish: Int?
//    let company: CompanyUploadMedia?
//    let from: FromUploadMedia?
//    let prevSession: PrevSessionUploadMedia?
//    let customer: CustomerUploadMedia?
//}
//
//struct MessageUploadMedia: Codable {
//    let fromType: String?
//    let template: AnyCodable?
//    let postback: PostbackUploadMedia?
//    let footer: AnyCodable?
//    let interactive: AnyCodable?
//    let retryTime: AnyCodable?
//    let media: MediaUploadMedia?
//    let type: String?
//    let retrySending: Int?
//    let unixMsgTime: Int?
//    let payload: String?
//    let receivedAt: String?
//    let processedAt: AnyCodable?
//    let header: AnyCodable?
//    let location: LocationUploadMedia?
//    let templateId: String?
//    let id: String?
//    let time: String?
//    let text: String?
//}
//
//struct MediaUploadMedia: Codable {
//    let size: Int?
//    let name: String?
//    let id: String?
//    let url: String?
//}
//
//struct AgentUploadMedia: Codable {
//    let priorityLevelId: String?
//    let priorityLevelName: String?
//    let userId: String?
//    let name: String?
//    let description: String?
//    let avatar: String?
//    let contactId: String?
//    let username: String?
//}
//
//struct CustomerUploadMedia: Codable {
//    let priorityLevelId: String?
//    let priorityLevelName: String?
//    let userId: String?
//    let name: String?
//    let description: String?
//    let avatar: String?
//    let contactId: String?
//    let username: String?
//}
//
//struct MetaUploadMedia: Codable {
//    let logId: String?
//    let code: Int?
//    let message: String?
//    let errors: AnyCodable?
//    let status: Bool?
//}
//
//struct CompanyUploadMedia: Codable {
//    let code: String?
//    let name: String?
//    let status: Bool?
//}
//
//struct LocationUploadMedia: Codable {
//    let address: String?
//    let livePeriod: Int?
//    let latitude: Int?
//    let name: String?
//    let longitude: Int?
//}
//
//struct FromUploadMedia: Codable {
//    let priorityLevelId: String?
//    let priorityLevelName: String?
//    let userId: String?
//    let name: String?
//    let description: String?
//    let avatar: String?
//    let contactId: String?
//    let username: String?
//}
//
//struct SessionUploadMedia: Codable {
//    let roomId: String?
//    let slaStatus: String?
//    let lastCustomerMessageTime: AnyCodable?
//    let openTime: AnyCodable?
//    let slaThreshold: Int?
//    let unixOpenTime: Int?
//    let slaFrom: String?
//    let openBy: String?
//    let id: String?
//    let categories: String?
//    let assignTime: AnyCodable?
//    let unixQueTime: Int?
//    let closeBy: String?
//    let handoverBy: String?
//    let unixAssignTime: Int?
//    let lastAgentChatTime: AnyCodable?
//    let botStatus: Bool?
//    let isNew: Bool?
//    let divisionId: String?
//    let closeTime: AnyCodable?
//    let slaTo: String?
//    let queueTime: AnyCodable?
//    let firstResponseTime: AnyCodable?
//    let slaDurations: Int?
//    let sessionPriorityLevelId: String?
//    let status: Int?
//}
//
//struct PostbackUploadMedia: Codable {
//    let type: String?
//    let title: String?
//    let value: String?
//    let key: String?
//}
//
//struct PrevSessionUploadMedia: Codable {
//    let openTime: AnyCodable?
//    let id: String?
//    let unixOpenTime: Int?
//}
