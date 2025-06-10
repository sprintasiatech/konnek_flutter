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
                    //                    print("Success getConfig: \(data)")
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
        case "getConversation":
            konnekService.getConversation(call: call, result: result) { output in
                switch output {
                case .success(let data):
                    //                    print("Success getConversation: \(data)")
                    result(data)
                case .failure(let error):
                    result(FlutterError(code: "API_ERROR",
                                        message: error.localizedDescription,
                                        details: nil,
                                       )
                    )
                }
            }
        case "sendChat":
            konnekService.sendChat(call: call, result: result) { output in
                switch output {
                case .success(let data):
                    //                    print("Success sendChat: \(data)")
                    if let jsonData = data.data(using: .utf8) {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                            
                            if let dataDict = jsonObject?["data"] as? [String: Any] {
                                let token = dataDict["token"] as? String ?? ""
                                
                                //                                print("token: \(token)")
                                KonnekFlutterPlugin.access = token
//                                print("KonnekFlutterPlugin.access: \(KonnekFlutterPlugin.access)")
                            }
                        } catch {
                            print("JSON error: \(error.localizedDescription)")
                        }
                    }
                    result(data)
                case .failure(let error):
                    result(FlutterError(code: "API_ERROR",
                                        message: error.localizedDescription,
                                        details: nil,
                                       )
                    )
                }
            }
        case "uploadMedia":
            konnekService.uploadMedia(call: call, result: result) { output in
                switch output {
                case .success(let data):
//                    print("Success uploadMedia: \(data)")
                    result(data)
                case .failure(let error):
                    result(FlutterError(code: "API_ERROR",
                                        message: error.localizedDescription,
                                        details: nil,
                                       )
                    )
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
        
        func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
    }
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
                        let clientId = args["clientId"] as? String,
                        let platformData = args["platform"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing clientId", details: nil))
                    return
                }
                
                KonnekFlutterPlugin.clientId = clientId
                
                Task {
                    do {
                        var apiService = try await ApiConfig().provideApiService()
                        var data = try await apiService.getConfig(
                            clientId: clientId,
                            platform: platformData,
                            completion: completion
                        )
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
            
            func getConversation(
                call: FlutterMethodCall,
                result: @escaping FlutterResult,
                completion: @escaping (Result<String, Error>) -> Void,
            ) {
                guard let args = call.arguments as? Dictionary<String, Any>,
                      let limit = args["limit"] as? String,
                      let roomId = args["roomId"] as? String,
                      let currentPage = args["currentPage"] as? String,
                      let sessionId = args["sessionId"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
                    return
                }
                
                Task {
                    do {
                        var apiService = try await ApiConfig().provideApiService()
                        var data = try await apiService.getConversation(
                            roomId: roomId,
                            currentPage: currentPage,
                            limit: limit,
                            sessionId: sessionId,
                            token: KonnekFlutterPlugin.access,
                            completion: completion
                        )
                        //                    var apiService = try await ApiConfig().provideApiService().getConversation(
                        //                        roomId: roomId,
                        //                        currentPage: currentPage,
                        //                        limit: limit,
                        //                        sessionId: sessionId,
                        //                        token: KonnekFlutterPlugin.access,
                        //                        completion: completion
                        //                    )
                        //                    var apiService = try await ApiConfig.provideApiService()
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
                    } catch {
                        result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
                    }
                }
            }
            
            func sendChat(
                call: FlutterMethodCall,
                result: @escaping FlutterResult,
                completion: @escaping (Result<String, Error>) -> Void,
            ) {
                guard let args = call.arguments as? Dictionary<String, Any>,
                    let clientId = args["clientId"] as? String,
                    let name = args["name"] as? String,
                    let username = args["username"] as? String,
                    let platformData = args["platform"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
                    return
                }
                
                KonnekFlutterPlugin.clientId = clientId
                let text = args["text"] as? String
                
                var payload: [String: Any] = [
                    "name": name,
                    "username": username
                ]
                if let text = text {
                    payload["text"] = text
                }
                
                Task {
                    do {
                        var apiService = try await ApiConfig().provideApiService()
                        var data = try await apiService.sendChat(
                            clientId: clientId,
                            platform: platformData,
                            body: payload,
                            completion: completion
                        )
                        //                    if let token = data.data?.token {
                        //                        KonnekFlutterPlugin.access = token
                        //                    }
                        //                    let jsonData = try jsonEncoder.encode(data)
                        //                    let jsonString = String(data: jsonData, encoding: .utf8)
                        //                    result(jsonString)
                    } catch {
                        result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
                    }
                }
            }
            //
            func uploadMedia(
                call: FlutterMethodCall,
                result: @escaping FlutterResult,
                completion: @escaping (Result<String, Error>) -> Void,
            ) {
                guard let args = call.arguments as? Dictionary<String, Any>,
                      let filePath = args["fileData"] as? String,
                      let messageId = args["messageId"] as? String,
                      let replyId = args["replyId"] as? String,
                      let text = args["text"] as? String,
                      let time = args["time"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing parameters", details: nil))
                    return
                }
                
                let fileUrl = URL(fileURLWithPath: filePath)
                guard FileManager.default.fileExists(atPath: fileUrl.path) else {
                    result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found at path", details: filePath))
                    return
                }
                lazy var dataFile = Data()
                do {
                    let fileData = try Data(contentsOf: fileUrl)
                    dataFile = fileData
                    // Now you can upload or manipulate `fileData`
                } catch {
                    print("Error reading file: \(error)")
                }
                
                Task {
                    do {
                        var apiService = try await ApiConfig().provideApiService()
                        let data = try await apiService.uploadMedia(
                            media: dataFile,
                            mediaFilename: filePath,
                            messageId: messageId,
                            replyId: replyId,
                            text: text,
                            time: time,
                            token: KonnekFlutterPlugin.access,
                            completion: completion
                        )
                        //                    let jsonData = try jsonEncoder.encode(data)
                        //                    let jsonString = String(data: jsonData, encoding: .utf8)
                        //                    result(jsonString)
                    } catch {
                        result(FlutterError(code: "UPLOAD_ERROR", message: error.localizedDescription, details: nil))
                    }
                }
            }
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
                platform: String,
                completion: @escaping (Result<String, Error>) -> Void
            ) {
                let urlString = "\(baseUrl)channel/config/\(clientId)/\(platform)"
                guard let url = URL(string: urlString) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                perform(request: request, completion: completion)
            }
            
            // MARK: - GET: Conversation
            func getConversation(
                roomId: String,
                currentPage: String,
                limit: String,
                sessionId: String,
                token: String,
                completion: @escaping (Result<String, Error>) -> Void
            ) {
                var urlComponents = URLComponents(string: "\(baseUrl)room/conversation/\(roomId)")!
                urlComponents.queryItems = [
                    URLQueryItem(name: "page", value: currentPage),
                    URLQueryItem(name: "limit", value: limit),
                    URLQueryItem(name: "sessionId", value: sessionId)
                ]
                
                guard let url = urlComponents.url else { return }
//                print("url getConversation: \(url)")
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                perform(request: request, completion: completion)
            }
            
            // MARK: - POST: Send Chat
            func sendChat(
                clientId: String,
                platform: String,
                body: [String: Any],
                completion: @escaping (Result<String, Error>) -> Void
            ) {
                let urlString = "\(baseUrl)webhook/\(platform)/\(clientId)"
                guard let url = URL(string: urlString) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //            request.httpBody = body
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                    request.httpBody = jsonData
                } catch {
                    print("Failed to serialize JSON: \(error)")
                }
                
                
                perform(request: request, completion: completion)
            }
            //
            // MARK: - POST: Upload Media
            func uploadMedia(
                media: Data,
                mediaFilename: String,
                messageId: String,
                replyId: String,
                text: String,
                time: String,
                token: String,
                completion: @escaping (Result<String, Error>) -> Void
            ) {
                let urlString = "\(baseUrl)chat/media"
                guard let url = URL(string: urlString) else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = UUID().uuidString
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
                
                let formData = createMultipartBody(
                    boundary: boundary,
                    media: media,
                    mediaFilename: mediaFilename,
                    messageId: messageId,
                    replyId: replyId,
                    text: text,
                    time: time
                )
                request.httpBody = formData
                
                perform(request: request, completion: completion)
            }
            
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
                    
                    // print("[perform] httpResponse \(httpResponse)")
                    // print("[perform] httpResponse.statusCode \(httpResponse.statusCode)")
                    
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
