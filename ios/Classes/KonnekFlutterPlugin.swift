import SwiftUI
import Flutter
import UIKit

public class KonnekFlutterPlugin: NSObject, FlutterPlugin {
    private static var CHANNEL_NAME = "konnek_flutter"
    static var clientId: String = ""
    static var access: String = ""
    
     var environmentConfig = EnvironmentConfig()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = KonnekFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
      }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         let konnekService = KonnekService()
        
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initialize":
            initialize(call: call, result: result)
        case "getConfig":
            konnekService.getConfig(call: call, result: result) { output in
                switch output {
                case .success(let data):
                    print("Success: \(data)")
                    result(data)
                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
                    result(FlutterError(code: "API_ERROR",
                                        message: error.localizedDescription,
                                        details: nil,
                                       )
                    )
                }
            }
//        case "getConversation":
//            konnekService.getConversation(call: call, result: result)
//        case "sendChat":
//            konnekService.sendChat(call: call, result: result)
//        case "uploadMedia":
//            konnekService.uploadMedia(call: call, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    
    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
            guard let args = call.arguments as? Dictionary<String, Any>,
                  let flavor = args["flavor"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'flavor'", details: nil))
                return
            }
        
//        print("result flavor", flavor, "")

            switch flavor.lowercased() {
            case "development":
                EnvironmentConfig.flavor = .development
            case "staging":
                EnvironmentConfig.flavor = .staging
            case "production":
                EnvironmentConfig.flavor = .production
            default:
                EnvironmentConfig.flavor = .staging
            }

            result("success initialize \(flavor)")
        }
        
////  ========================================================================================================================================
////  ========================================================================================================================================
    class KonnekService {
        private let jsonEncoder = JSONEncoder()
        private let jsonDecoder = JSONDecoder()
        
        static var apiConfig = ApiConfig()
        
        func getConfig(
            call: FlutterMethodCall,
            result: @escaping FlutterResult,
            completion: @escaping (Result<String, Error>) -> Void
        ) {
            guard let args = call.arguments as? Dictionary<String, Any>,
                  let clientId = args["clientId"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing clientId", details: nil))
                return
            }

            KonnekFlutterPlugin.clientId = clientId
            
            Task {
                do {
                    var apiService = try await ApiConfig().provideApiService().getConfig(clientId: clientId, completion: completion)
//                    var data = try await apiService().getConfig(
//                        clientId: clientId,
//                        completion: completion
//                    )
//                    let jsonData = try jsonEncoder.encode(data)
//                    let jsonData = try JSONEncoder().encode(apiService)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                    result(jsonString)
                } catch {
                    result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }

//        func getConversation(call: FlutterMethodCall, result: @escaping FlutterResult) {
//            guard let args = call.arguments as? Dictionary<String, Any>,
//                  let roomId = args["roomId"] as? String,
//                  let currentPage = args["currentPage"] as? String,
//                  let limit = args["limit"] as? String,
//                  let sessionId = args["sessionId"] as? String else {
//                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//                return
//            }
//
//            Task {
//                do {
//                    var apiService = try await ApiConfig.provideApiService(<#T##self: KonnekFlutterPlugin.ApiConfig##KonnekFlutterPlugin.ApiConfig#>)
//                    var data = try await apiService().getConversation(
//                        roomId: roomId,
//                        currentPage: currentPage,
//                        limit: limit,
//                        sessionId: sessionId,
//                        accessToken: KonnekFlutterPlugin.access,
//                        
//                    )
//                    let jsonData = try jsonEncoder.encode(data)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                    result(jsonString)
//                } catch {
//                    result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
//                }
//            }
//        }
//
//        func sendChat(call: FlutterMethodCall, result: @escaping FlutterResult) {
//            guard let args = call.arguments as? Dictionary<String, Any>,
//                  let clientId = args["clientId"] as? String,
//                  let name = args["name"] as? String,
//                  let username = args["username"] as? String else {
//                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//                return
//            }
//
//            KonnekFlutterPlugin.clientId = clientId
//            let text = args["text"] as? String
//
//            var payload: [String: Any] = [
//                "name": name,
//                "username": username
//            ]
//            if let text = text {
//                payload["text"] = text
//            }
//
//            Task {
//                do {
//                    var apiService = try await ApiConfig.provideApiService(<#T##self: KonnekFlutterPlugin.ApiConfig##KonnekFlutterPlugin.ApiConfig#>)
//                    var data = try await apiService().sendChat(
//                        clientId: clientId,
//                        body: payload
//                    )
//                    if let token = data.data?.token {
//                        KonnekFlutterPlugin.access = token
//                    }
//                    let jsonData = try jsonEncoder.encode(data)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                    result(jsonString)
//                } catch {
//                    result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
//                }
//            }
//        }
//
//        func uploadMedia(call: FlutterMethodCall, result: @escaping FlutterResult) {
//            guard let args = call.arguments as? Dictionary<String, Any>,
//                  let filePath = args["fileData"] as? String,
//                  let messageId = args["messageId"] as? String,
//                  let replyId = args["replyId"] as? String,
//                  let text = args["text"] as? String,
//                  let time = args["time"] as? String else {
//                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//                return
//            }
//
//            let fileUrl = URL(fileURLWithPath: filePath)
//            guard FileManager.default.fileExists(atPath: fileUrl.path) else {
//                result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found at path", details: filePath))
//                return
//            }
//
//            Task {
//                do {
//                    var apiService = try await ApiConfig.provideApiService(<#T##self: KonnekFlutterPlugin.ApiConfig##KonnekFlutterPlugin.ApiConfig#>)
//                    let data = try await apiService().uploadMedia(
//                        fileURL: fileUrl,
//                        messageId: messageId,
//                        replyId: replyId,
//                        text: text,
//                        time: time,
//                        accessToken: KonnekFlutterPlugin.access
//                    )
//                    let jsonData = try jsonEncoder.encode(data)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                    result(jsonString)
//                } catch {
//                    result(FlutterError(code: "UPLOAD_ERROR", message: error.localizedDescription, details: nil))
//                }
//            }
//        }
    }
//    
////  ========================================================================================================================================
////  ========================================================================================================================================
//    
    enum Flavor {
        case development
        case staging
        case production
    }
//    
////    class Parent {
////        class ChildOne {
////            func sayHello() {
////                print("Hello from Child One")
////            }
////        }
////        
////        class ChildTwo {
////            var child1 = Parent.ChildOne().sayHello()
////            func sayHello() {
////                print("Hello from Child Two")
////            }
////        }
////    }
////
////    // Create instances of nested classes using Parent.ClassName
////    let child1 = Parent.ChildOne()
////    let child2 = Parent.ChildTwo().sayHello()
//
    class EnvironmentConfig {
        static var flavor: Flavor = .staging

        private static var _baseUrl: String = ""
        private static var _baseUrlSocket: String = ""

        static var customBaseUrl: String {
            get {
                if _baseUrl.isEmpty {
                    switch flavor {
                    case .development:
                        return "http://192.168.1.74:8080/"
                    case .staging:
                        return "https://stg.wekonnek.id:9443/"
                    case .production:
                        return "https://wekonnek.id:9443/"
                    }
                } else {
                    return _baseUrl
                }
            }
            set {
                _baseUrl = newValue
            }
        }

        static func baseUrl() -> String {
            return customBaseUrl
        }

        static var customBaseUrlSocket: String {
            get {
                if _baseUrlSocket.isEmpty {
                    switch flavor {
                    case .development:
                        return "http://192.168.1.74:3000/"
                    case .staging:
                        return "https://stgsck.wekonnek.id:3001/"
                    case .production:
                        return "https://sck.wekonnek.id:3001/"
                    }
                } else {
                    return _baseUrlSocket
                }
            }
            set {
                _baseUrlSocket = newValue
            }
        }

        static func baseUrlSocket() -> String {
            return customBaseUrlSocket
        }
    }
//
////  ========================================================================================================================================
////  ========================================================================================================================================
//    
    class ApiService {
        private let session: URLSession
        private let baseUrl: String

        init(session: URLSession = .shared, baseUrl: String) {
            self.session = session
            self.baseUrl = baseUrl
        }

        // MARK: - GET: Config
        func getConfig(
            clientId: String,
            completion: @escaping (Result<String, Error>) -> Void
        ) {
            let urlString = "\(baseUrl)channel/config/\(clientId)/web"
//            print("urlString \(urlString)")
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            perform(request: request, completion: completion)
        }

//        // MARK: - GET: Conversation
//        func getConversation(
//            roomId: String,
//            currentPage: String,
//            limit: String,
//            sessionId: String,
//            token: String,
//            completion: @escaping (Result<GetConversationResponseModel, Error>) -> Void
//        ) {
//            var urlComponents = URLComponents(string: "\(baseUrl)/room/conversation/\(roomId)")!
//            urlComponents.queryItems = [
//                URLQueryItem(name: "currentPage", value: currentPage),
//                URLQueryItem(name: "limit", value: limit),
//                URLQueryItem(name: "sessionId", value: sessionId)
//            ]
//
//            guard let url = urlComponents.url else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            perform(request: request, completion: completion)
//        }
//
//        // MARK: - POST: Send Chat
//        func sendChat(
//            clientId: String,
//            body: Data,
//            completion: @escaping (Result<SendChatResponseModel, Error>) -> Void
//        ) {
//            let urlString = "\(baseUrl)/webhook/widget/\(clientId)"
//            guard let url = URL(string: urlString) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = body
//
//            perform(request: request, completion: completion)
//        }
//
//        // MARK: - POST: Upload Media
//        func uploadMedia(
//            media: Data,
//            mediaFilename: String,
//            messageId: String,
//            replyId: String,
//            text: String,
//            time: String,
//            token: String,
//            completion: @escaping (Result<UploadMediaResponseModel, Error>) -> Void
//        ) {
//            let urlString = "\(baseUrl)/chat/media"
//            guard let url = URL(string: urlString) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            let boundary = UUID().uuidString
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
//
//            let formData = createMultipartBody(
//                boundary: boundary,
//                media: media,
//                mediaFilename: mediaFilename,
//                messageId: messageId,
//                replyId: replyId,
//                text: text,
//                time: time
//            )
//            request.httpBody = formData
//
//            perform(request: request, completion: completion)
//        }

//        // MARK: - Perform Request
//        private func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
//            session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    return completion(.failure(error))
//                }
//
//                guard let data = data else {
//                    return completion(.failure(NSError(domain: "No data", code: -1)))
//                }
//
//                do {
//                    let decoded = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(decoded))
//                } catch {
//                    completion(.failure(error))
//                }
//            }.resume()
//        }
        
        // MARK: - Perform Request and Return JSON String
        private func perform(request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
                
//                print("[perform] httpResponse \(httpResponse)")
                print("[perform] httpResponse.statusCode \(httpResponse.statusCode)")

                guard let data = data else {
                    return completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                }
                
//                print("[perform] data \(data)")
                
                guard let jsonString = String(data: data, encoding: .utf8) else {
                    return completion(.failure(NSError(domain: "Invalid UTF-8 encoding", code: -3, userInfo: nil)))
                }
                
                completion(.success(jsonString))


//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("[perform] jsonString \(jsonString)")
//                    completion(.success(jsonString))
//                } else {
//                    completion(.failure(NSError(domain: "Invalid UTF-8 encoding", code: -2, userInfo: nil)))
//                }
            }.resume()
        }


        // MARK: - Multipart Creator
        private func createMultipartBody(boundary: String, media: Data, mediaFilename: String, messageId: String, replyId: String, text: String, time: String) -> Data {
            var body = Data()

            func appendFormField(_ name: String, value: String) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }

            func appendFileField(_ name: String, filename: String, data: Data, mimeType: String) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }

            appendFileField("media", filename: mediaFilename, data: media, mimeType: "image/jpeg")
            appendFormField("message_id", value: messageId)
            appendFormField("reply_id", value: replyId)
            appendFormField("text", value: text)
            appendFormField("time", value: time)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            return body
        }
    }
//    
////  ========================================================================================================================================
////  ========================================================================================================================================
//    
    class ApiConfig {
        private var baseUrl = EnvironmentConfig.baseUrl()
        private let session: URLSession
        
        init() {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 120
            config.timeoutIntervalForResource = 120
            
            // Attach logging if needed
            // config.protocolClasses = [LoggingURLProtocol.self] + (config.protocolClasses ?? [])
            
            self.session = URLSession(configuration: config)
        }
        
        func provideApiService() -> ApiService {
            return ApiService(session: session, baseUrl: baseUrl)
        }
    }
//    
////  ========================================================================================================================================
////  ========================================================================================================================================
//    
    // MARK: - AnyCodable (for errors)
//    struct AnyCodable: Codable {}
    
    struct GetConfigResponseModel: Encodable {
        let data: DataGetConfig?
        let meta: MetaGetConfig?
    }

    struct DataGetConfig: Encodable {
        let preview: String?
        let backgroundStatus: String?
        let widgetIcon: String?
        let companyId: String?
        let headerTextColor: String?
        let textButtonColor: String?
        let avatarImage: String?
        let textButton: String?
        let headerBackgroundColor: String?
        let buttonColor: String?
        let greetingMessage: String?
        let background: String?
        let avatarName: String?
        let status: Bool?

        enum CodingKeys: String, CodingKey {
            case preview
            case backgroundStatus = "background_status"
            case widgetIcon = "widget_icon"
            case companyId = "company_id"
            case headerTextColor = "header_text_color"
            case textButtonColor = "text_button_color"
            case avatarImage = "avatar_image"
            case textButton = "text_button"
            case headerBackgroundColor = "header_background_color"
            case buttonColor = "button_color"
            case greetingMessage = "greeting_message"
            case background
            case avatarName = "avatar_name"
            case status
        }
    }

    struct MetaGetConfig: Encodable {
        let logId: String?
        let code: Int?
        let message: String?
        let errors: String?  // We'll handle dynamic typing here
        let status: Bool?

        enum CodingKeys: String, CodingKey {
            case logId = "log_id"
            case code
            case message
            case errors
            case status
        }
    }
//    
//    
////  ========================================================================================================================================
////  ========================================================================================================================================
//    
//    // MARK: - Root Response
//    struct GetConversationResponseModel: Codable {
//        let data: DataGetConversation?
//        let meta: MetaGetConversation?
//    }
//
//    // MARK: - Data Section
//    struct DataGetConversation: Codable {
//        let expire: String?
//        let conversations: [ConversationsItemGetConversation?]?
//        let room: RoomGetConversation?
//        let token: String?
//    }
//
//    // MARK: - Meta Section
//    struct MetaGetConversation: Codable {
//        let nextPage: Bool?
//        let logId: String?
//        let perPage: Int?
//        let code: Int?
//        let totalCount: Int?
//        let message: String?
//        let prevPage: Bool?
//        let errors: AnyCodable?
//        let currentPage: Int?
//        let pageCount: Int?
//        let status: Bool?
//
//        enum CodingKeys: String, CodingKey {
//            case nextPage = "next_page"
//            case logId = "log_id"
//            case perPage = "per_page"
//            case code
//            case totalCount = "total_count"
//            case message
//            case prevPage = "prev_page"
//            case errors
//            case currentPage = "current_page"
//            case pageCount = "page_count"
//            case status
//        }
//    }
//
//    // MARK: - Conversations Item
//    struct ConversationsItemGetConversation: Codable {
//        let roomId: String?
//        let fromType: String?
//        let session: SessionGetConversation?
//        let sessionId: String?
//        let createdAt: String?
//        let messageId: String?
//        let type: String?
//        let createdBy: String?
//        let messageTime: String?
//        let replyId: String?
//        let userId: String?
//        let payload: String?
//        let unixMsgTime: Int64?
//        let seqId: Int?
//        let id: String?
//        let text: String?
//        let user: UserGetConversation?
//        let status: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case roomId = "room_id"
//            case fromType = "from_type"
//            case session
//            case sessionId = "session_id"
//            case createdAt = "created_at"
//            case messageId = "message_id"
//            case type
//            case createdBy = "created_by"
//            case messageTime = "message_time"
//            case replyId = "reply_id"
//            case userId = "user_id"
//            case payload
//            case unixMsgTime = "unix_msg_time"
//            case seqId = "seq_id"
//            case id
//            case text
//            case user
//            case status
//        }
//    }
//
//    // MARK: - Room
//    struct RoomGetConversation: Codable {
//        let customerDescription: String?
//        let lastCustomerMessageTime: String?
//        let openTime: String?
//        let channelCode: String?
//        let customerUsername: String?
//        let openBy: String?
//        let assignTime: String?
//        let categories: String?
//        let id: String?
//        let closeBy: String?
//        let handoverBy: String?
//        let agentUserId: String?
//        let lastAgentChatTime: String?
//        let companyId: String?
//        let botStatus: Bool?
//        let divisionId: String?
//        let sessionId: String?
//        let sendOutboundFlag: Bool?
//        let closeTime: String?
//        let queueTime: String?
//        let customerAvatar: String?
//        let firstResponseTime: String?
//        let customerEmail: String?
//        let customerName: String?
//        let customerId: String?
//        let windowMessaging: String?
//        let status: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case customerDescription = "customer_description"
//            case lastCustomerMessageTime = "last_customer_message_time"
//            case openTime = "open_time"
//            case channelCode = "channel_code"
//            case customerUsername = "customer_username"
//            case openBy = "open_by"
//            case assignTime = "assign_time"
//            case categories
//            case id
//            case closeBy = "close_by"
//            case handoverBy = "handover_by"
//            case agentUserId = "agent_user_id"
//            case lastAgentChatTime = "last_agent_chat_time"
//            case companyId = "company_id"
//            case botStatus = "bot_status"
//            case divisionId = "division_id"
//            case sessionId = "session_id"
//            case sendOutboundFlag = "send_outbound_flag"
//            case closeTime = "close_time"
//            case queueTime = "queue_time"
//            case customerAvatar = "customer_avatar"
//            case firstResponseTime = "first_response_time"
//            case customerEmail = "customer_email"
//            case customerName = "customer_name"
//            case customerId = "customer_id"
//            case windowMessaging = "window_messaging"
//            case status
//        }
//    }
//
//    // MARK: - Session
//    struct SessionGetConversation: Codable {
//        let roomId: String?
//        let agentUserId: String?
//        let lastAgentChatTime: String?
//        let agent: AgentGetConversation?
//        let botStatus: Bool?
//        let divisionId: String?
//        let openTime: String?
//        let closeTime: String?
//        let closeUser: CloseUserGetConversation?
//        let queueTime: String?
//        let firstResponseTime: String?
//        let sessionPriorityLevelId: String?
//        let openBy: String?
//        let id: String?
//        let categories: String?
//        let assignTime: String?
//        let closeBy: String?
//        let handoverBy: String?
//        let status: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case roomId = "room_id"
//            case agentUserId = "agent_user_id"
//            case lastAgentChatTime = "last_agent_chat_time"
//            case agent
//            case botStatus = "bot_status"
//            case divisionId = "division_id"
//            case openTime = "open_time"
//            case closeTime = "close_time"
//            case closeUser = "close_user"
//            case queueTime = "queue_time"
//            case firstResponseTime = "first_response_time"
//            case sessionPriorityLevelId = "session_priority_level_id"
//            case openBy = "open_by"
//            case id
//            case categories
//            case assignTime = "assign_time"
//            case closeBy = "close_by"
//            case handoverBy = "handover_by"
//            case status
//        }
//    }
//
//    // MARK: - Agent/User/CloseUser
//    struct AgentGetConversation: Codable {
//        let onlineStatus: Int?
//        let customerChannel: String?
//        let description: String?
//        let divisionId: String?
//        let avatar: String?
//        let tags: String?
//        let isBlocked: Bool?
//        let phone: String?
//        let name: String?
//        let id: String?
//        let email: String?
//        let username: String?
//        let status: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case onlineStatus = "online_status"
//            case customerChannel = "customer_channel"
//            case description
//            case divisionId = "division_id"
//            case avatar
//            case tags
//            case isBlocked = "is_blocked"
//            case phone
//            case name
//            case id
//            case email
//            case username
//            case status
//        }
//    }
//
//    typealias UserGetConversation = AgentGetConversation
//    typealias CloseUserGetConversation = AgentGetConversation
//
//    
////
////
//    
//    struct SendChatResponseModel: Codable {
//        let data: DataSendChat?
//        let meta: MetaSendChat?
//    }
//
//    // MARK: - Data Section
//    struct DataSendChat: Codable {
//        let expire: String?
//        let sessionId: String?
//        let tid: String?
//        let token: String?
//
//        enum CodingKeys: String, CodingKey {
//            case expire
//            case sessionId = "session_id"
//            case tid
//            case token
//        }
//    }
//
//    // MARK: - Meta Section
//    struct MetaSendChat: Codable {
//        let logId: String?
//        let code: Int?
//        let message: String?
//        let errors: AnyCodable?
//        let status: Bool?
//
//        enum CodingKeys: String, CodingKey {
//            case logId = "log_id"
//            case code
//            case message
//            case errors
//            case status
//        }
//    }
//
//    
////
////
//    
//    struct UploadMediaResponseModel: Codable {
//        let data: DataUploadMedia?
//        let meta: MetaUploadMedia?
//    }
//
//    struct DataUploadMedia: Codable {
//        let replyToken: String?
//        let agent: AgentUploadMedia?
//        let companyId: String?
//        let session: SessionUploadMedia?
//        let providerMessageId: String?
//        let messageId: String?
//        let channelCode: String?
//        let message: MessageUploadMedia?
//        let error: AnyCodable?
//        let csat: AnyCodable?
//        let replyId: String?
//        let republish: Int?
//        let company: CompanyUploadMedia?
//        let from: FromUploadMedia?
//        let prevSession: PrevSessionUploadMedia?
//        let customer: CustomerUploadMedia?
//    }
//
//    struct MessageUploadMedia: Codable {
//        let fromType: String?
//        let template: AnyCodable?
//        let postback: PostbackUploadMedia?
//        let footer: AnyCodable?
//        let interactive: AnyCodable?
//        let retryTime: AnyCodable?
//        let media: MediaUploadMedia?
//        let type: String?
//        let retrySending: Int?
//        let unixMsgTime: Int?
//        let payload: String?
//        let receivedAt: String?
//        let processedAt: AnyCodable?
//        let header: AnyCodable?
//        let location: LocationUploadMedia?
//        let templateId: String?
//        let id: String?
//        let time: String?
//        let text: String?
//    }
//
//    struct MediaUploadMedia: Codable {
//        let size: Int?
//        let name: String?
//        let id: String?
//        let url: String?
//    }
//
//    struct AgentUploadMedia: Codable {
//        let priorityLevelId: String?
//        let priorityLevelName: String?
//        let userId: String?
//        let name: String?
//        let description: String?
//        let avatar: String?
//        let contactId: String?
//        let username: String?
//    }
//
//    struct CustomerUploadMedia: Codable {
//        let priorityLevelId: String?
//        let priorityLevelName: String?
//        let userId: String?
//        let name: String?
//        let description: String?
//        let avatar: String?
//        let contactId: String?
//        let username: String?
//    }
//
//    struct MetaUploadMedia: Codable {
//        let logId: String?
//        let code: Int?
//        let message: String?
//        let errors: AnyCodable?
//        let status: Bool?
//    }
//
//    struct CompanyUploadMedia: Codable {
//        let code: String?
//        let name: String?
//        let status: Bool?
//    }
//
//    struct LocationUploadMedia: Codable {
//        let address: String?
//        let livePeriod: Int?
//        let latitude: Int?
//        let name: String?
//        let longitude: Int?
//    }
//
//    struct FromUploadMedia: Codable {
//        let priorityLevelId: String?
//        let priorityLevelName: String?
//        let userId: String?
//        let name: String?
//        let description: String?
//        let avatar: String?
//        let contactId: String?
//        let username: String?
//    }
//
//    struct SessionUploadMedia: Codable {
//        let roomId: String?
//        let slaStatus: String?
//        let lastCustomerMessageTime: AnyCodable?
//        let openTime: AnyCodable?
//        let slaThreshold: Int?
//        let unixOpenTime: Int?
//        let slaFrom: String?
//        let openBy: String?
//        let id: String?
//        let categories: String?
//        let assignTime: AnyCodable?
//        let unixQueTime: Int?
//        let closeBy: String?
//        let handoverBy: String?
//        let unixAssignTime: Int?
//        let lastAgentChatTime: AnyCodable?
//        let botStatus: Bool?
//        let isNew: Bool?
//        let divisionId: String?
//        let closeTime: AnyCodable?
//        let slaTo: String?
//        let queueTime: AnyCodable?
//        let firstResponseTime: AnyCodable?
//        let slaDurations: Int?
//        let sessionPriorityLevelId: String?
//        let status: Int?
//    }
//
//    struct PostbackUploadMedia: Codable {
//        let type: String?
//        let title: String?
//        let value: String?
//        let key: String?
//    }
//
//    struct PrevSessionUploadMedia: Codable {
//        let openTime: AnyCodable?
//        let id: String?
//        let unixOpenTime: Int?
//    }

}


//public class KonnekFlutterPlugin: NSObject, FlutterPlugin {
////    private var konnekService = KonnekService()
//    private static var CHANNEL_NAME = "konnek_flutter"
//    
//    public static func register(with registrar: FlutterPluginRegistrar) {
//        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
//        let instance = KonnekFlutterPlugin()
//        registrar.addMethodCallDelegate(instance, channel: channel)
//      }
//
//    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let konnekService = KonnekService()
//        
//        switch call.method {
//        case "getPlatformVersion":
//            result("iOS " + UIDevice.current.systemVersion)
//        case "initialize":
//            initialize(call: call, result: result)
//        case "getConfig":
//            konnekService.getConfig(call: call, result: result)
//        case "getConversation":
//            konnekService.getConversation(call: call, result: result)
//        case "sendChat":
//            konnekService.sendChat(call: call, result: result)
//        case "uploadMedia":
//            konnekService.uploadMedia(call: call, result: result)
//        default:
//          result(FlutterMethodNotImplemented)
//        }
//      }
//    
//    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
//            guard let args = call.arguments as? Dictionary<String, Any>,
//                  let flavor = args["flavor"] as? String else {
//                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'flavor'", details: nil))
//                return
//            }
//
//            switch flavor.lowercased() {
//            case "development":
//                EnvironmentConfig.flavor = .development
//            case "staging":
//                EnvironmentConfig.flavor = .staging
//            case "production":
//                EnvironmentConfig.flavor = .production
//            default:
//                EnvironmentConfig.flavor = .staging
//            }
//
//            result("success initialize \(flavor)")
//        }
//}
