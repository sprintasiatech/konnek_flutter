//import Foundation
//
//// MARK: - Root Response
//struct GetConversationResponseModel: Codable {
//    let data: DataGetConversation?
//    let meta: MetaGetConversation?
//}
//
//// MARK: - Data Section
//struct DataGetConversation: Codable {
//    let expire: String?
//    let conversations: [ConversationsItemGetConversation?]?
//    let room: RoomGetConversation?
//    let token: String?
//}
//
//// MARK: - Meta Section
//struct MetaGetConversation: Codable {
//    let nextPage: Bool?
//    let logId: String?
//    let perPage: Int?
//    let code: Int?
//    let totalCount: Int?
//    let message: String?
//    let prevPage: Bool?
//    let errors: AnyCodable?
//    let currentPage: Int?
//    let pageCount: Int?
//    let status: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case nextPage = "next_page"
//        case logId = "log_id"
//        case perPage = "per_page"
//        case code
//        case totalCount = "total_count"
//        case message
//        case prevPage = "prev_page"
//        case errors
//        case currentPage = "current_page"
//        case pageCount = "page_count"
//        case status
//    }
//}
//
//// MARK: - Conversations Item
//struct ConversationsItemGetConversation: Codable {
//    let roomId: String?
//    let fromType: String?
//    let session: SessionGetConversation?
//    let sessionId: String?
//    let createdAt: String?
//    let messageId: String?
//    let type: String?
//    let createdBy: String?
//    let messageTime: String?
//    let replyId: String?
//    let userId: String?
//    let payload: String?
//    let unixMsgTime: Int64?
//    let seqId: Int?
//    let id: String?
//    let text: String?
//    let user: UserGetConversation?
//    let status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case roomId = "room_id"
//        case fromType = "from_type"
//        case session
//        case sessionId = "session_id"
//        case createdAt = "created_at"
//        case messageId = "message_id"
//        case type
//        case createdBy = "created_by"
//        case messageTime = "message_time"
//        case replyId = "reply_id"
//        case userId = "user_id"
//        case payload
//        case unixMsgTime = "unix_msg_time"
//        case seqId = "seq_id"
//        case id
//        case text
//        case user
//        case status
//    }
//}
//
//// MARK: - Room
//struct RoomGetConversation: Codable {
//    let customerDescription: String?
//    let lastCustomerMessageTime: String?
//    let openTime: String?
//    let channelCode: String?
//    let customerUsername: String?
//    let openBy: String?
//    let assignTime: String?
//    let categories: String?
//    let id: String?
//    let closeBy: String?
//    let handoverBy: String?
//    let agentUserId: String?
//    let lastAgentChatTime: String?
//    let companyId: String?
//    let botStatus: Bool?
//    let divisionId: String?
//    let sessionId: String?
//    let sendOutboundFlag: Bool?
//    let closeTime: String?
//    let queueTime: String?
//    let customerAvatar: String?
//    let firstResponseTime: String?
//    let customerEmail: String?
//    let customerName: String?
//    let customerId: String?
//    let windowMessaging: String?
//    let status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case customerDescription = "customer_description"
//        case lastCustomerMessageTime = "last_customer_message_time"
//        case openTime = "open_time"
//        case channelCode = "channel_code"
//        case customerUsername = "customer_username"
//        case openBy = "open_by"
//        case assignTime = "assign_time"
//        case categories
//        case id
//        case closeBy = "close_by"
//        case handoverBy = "handover_by"
//        case agentUserId = "agent_user_id"
//        case lastAgentChatTime = "last_agent_chat_time"
//        case companyId = "company_id"
//        case botStatus = "bot_status"
//        case divisionId = "division_id"
//        case sessionId = "session_id"
//        case sendOutboundFlag = "send_outbound_flag"
//        case closeTime = "close_time"
//        case queueTime = "queue_time"
//        case customerAvatar = "customer_avatar"
//        case firstResponseTime = "first_response_time"
//        case customerEmail = "customer_email"
//        case customerName = "customer_name"
//        case customerId = "customer_id"
//        case windowMessaging = "window_messaging"
//        case status
//    }
//}
//
//// MARK: - Session
//struct SessionGetConversation: Codable {
//    let roomId: String?
//    let agentUserId: String?
//    let lastAgentChatTime: String?
//    let agent: AgentGetConversation?
//    let botStatus: Bool?
//    let divisionId: String?
//    let openTime: String?
//    let closeTime: String?
//    let closeUser: CloseUserGetConversation?
//    let queueTime: String?
//    let firstResponseTime: String?
//    let sessionPriorityLevelId: String?
//    let openBy: String?
//    let id: String?
//    let categories: String?
//    let assignTime: String?
//    let closeBy: String?
//    let handoverBy: String?
//    let status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case roomId = "room_id"
//        case agentUserId = "agent_user_id"
//        case lastAgentChatTime = "last_agent_chat_time"
//        case agent
//        case botStatus = "bot_status"
//        case divisionId = "division_id"
//        case openTime = "open_time"
//        case closeTime = "close_time"
//        case closeUser = "close_user"
//        case queueTime = "queue_time"
//        case firstResponseTime = "first_response_time"
//        case sessionPriorityLevelId = "session_priority_level_id"
//        case openBy = "open_by"
//        case id
//        case categories
//        case assignTime = "assign_time"
//        case closeBy = "close_by"
//        case handoverBy = "handover_by"
//        case status
//    }
//}
//
//// MARK: - Agent/User/CloseUser
//struct AgentGetConversation: Codable {
//    let onlineStatus: Int?
//    let customerChannel: String?
//    let description: String?
//    let divisionId: String?
//    let avatar: String?
//    let tags: String?
//    let isBlocked: Bool?
//    let phone: String?
//    let name: String?
//    let id: String?
//    let email: String?
//    let username: String?
//    let status: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case onlineStatus = "online_status"
//        case customerChannel = "customer_channel"
//        case description
//        case divisionId = "division_id"
//        case avatar
//        case tags
//        case isBlocked = "is_blocked"
//        case phone
//        case name
//        case id
//        case email
//        case username
//        case status
//    }
//}
//
//typealias UserGetConversation = AgentGetConversation
//typealias CloseUserGetConversation = AgentGetConversation
//
//// MARK: - AnyCodable (for errors)
//struct AnyCodable: Codable {}
