//import Foundation
//import Flutter
//
//class KonnekService {
//    static let shared = KonnekService()
//    
//    private let jsonEncoder = JSONEncoder()
//    private let jsonDecoder = JSONDecoder()
//    
//    func getConfig(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        guard let args = call.arguments as? Dictionary<String, Any>,
//              let clientId = args["clientId"] as? String else {
//            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing clientId", details: nil))
//            return
//        }
//
//        KonnekFlutterPlugin.clientId = clientId
//        
//        Task {
//            do {
//                let data = try await ApiConfig.shared.getConfig(clientId: clientId)
//                let jsonData = try jsonEncoder.encode(data)
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                result(jsonString)
//            } catch {
//                result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
//            }
//        }
//    }
//
//    func getConversation(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        guard let args = call.arguments as? Dictionary<String, Any>,
//              let roomId = args["roomId"] as? String,
//              let currentPage = args["currentPage"] as? String,
//              let limit = args["limit"] as? String,
//              let sessionId = args["sessionId"] as? String else {
//            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//            return
//        }
//
//        Task {
//            do {
//                let data = try await ApiConfig.shared.getConversation(roomId: roomId, currentPage: currentPage, limit: limit, sessionId: sessionId, accessToken: KonnekFlutterPlugin.access)
//                let jsonData = try jsonEncoder.encode(data)
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                result(jsonString)
//            } catch {
//                result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
//            }
//        }
//    }
//
//    func sendChat(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        guard let args = call.arguments as? Dictionary<String, Any>,
//              let clientId = args["clientId"] as? String,
//              let name = args["name"] as? String,
//              let username = args["username"] as? String else {
//            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//            return
//        }
//
//        KonnekFlutterPlugin.clientId = clientId
//        let text = args["text"] as? String
//
//        var payload: [String: Any] = [
//            "name": name,
//            "username": username
//        ]
//        if let text = text {
//            payload["text"] = text
//        }
//
//        Task {
//            do {
//                let data = try await ApiConfig.shared.sendChat(clientId: clientId, body: payload)
//                if let token = data.data?.token {
//                    KonnekFlutterPlugin.access = token
//                }
//                let jsonData = try jsonEncoder.encode(data)
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                result(jsonString)
//            } catch {
//                result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
//            }
//        }
//    }
//
//    func uploadMedia(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        guard let args = call.arguments as? Dictionary<String, Any>,
//              let filePath = args["fileData"] as? String,
//              let messageId = args["messageId"] as? String,
//              let replyId = args["replyId"] as? String,
//              let text = args["text"] as? String,
//              let time = args["time"] as? String else {
//            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
//            return
//        }
//
//        let fileUrl = URL(fileURLWithPath: filePath)
//        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
//            result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found at path", details: filePath))
//            return
//        }
//
//        Task {
//            do {
//                let data = try await ApiConfig.shared.uploadMedia(
//                    fileURL: fileUrl,
//                    messageId: messageId,
//                    replyId: replyId,
//                    text: text,
//                    time: time,
//                    accessToken: KonnekFlutterPlugin.access
//                )
//                let jsonData = try jsonEncoder.encode(data)
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                result(jsonString)
//            } catch {
//                result(FlutterError(code: "UPLOAD_ERROR", message: error.localizedDescription, details: nil))
//            }
//        }
//    }
//}
