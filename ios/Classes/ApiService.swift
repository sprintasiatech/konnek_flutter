//import Foundation
//import UIKit
//
//class ApiService {
//    private let session: URLSession
//    private let baseUrl: String
//
//    init(session: URLSession = .shared, baseUrl: String) {
//        self.session = session
//        self.baseUrl = baseUrl
//    }
//
//    // MARK: - GET: Config
//    func getConfig(
//        clientId: String,
//        completion: @escaping (Result<GetConfigResponseModel, Error>) -> Void
//    ) {
//        let urlString = "\(baseUrl)/channel/config/\(clientId)/web"
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        perform(request: request, completion: completion)
//    }
//
//    // MARK: - GET: Conversation
//    func getConversation(
//        roomId: String,
//        currentPage: String,
//        limit: String,
//        sessionId: String,
//        token: String,
//        completion: @escaping (Result<GetConversationResponseModel, Error>,) -> Void
//    ) {
//        var urlComponents = URLComponents(string: "\(baseUrl)/room/conversation/\(roomId)")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "currentPage", value: currentPage),
//            URLQueryItem(name: "limit", value: limit),
//            URLQueryItem(name: "sessionId", value: sessionId)
//        ]
//
//        guard let url = urlComponents.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        perform(request: request, completion: completion)
//    }
//
//    // MARK: - POST: Send Chat
//    func sendChat(
//        clientId: String,
//        body: Data,
//        completion: @escaping (Result<SendChatResponseModel, Error>) -> Void
//    ) {
//        let urlString = "\(baseUrl)/webhook/widget/\(clientId)"
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//
//        perform(request: request, completion: completion)
//    }
//
//    // MARK: - POST: Upload Media
//    func uploadMedia(
//        media: Data,
//        mediaFilename: String,
//        messageId: String,
//        replyId: String,
//        text: String,
//        time: String,
//        token: String,
//        completion: @escaping (Result<UploadMediaResponseModel, Error>) -> Void
//    ) {
//        let urlString = "\(baseUrl)/chat/media"
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
//
//        let formData = createMultipartBody(
//            boundary: boundary,
//            media: media,
//            mediaFilename: mediaFilename,
//            messageId: messageId,
//            replyId: replyId,
//            text: text,
//            time: time
//        )
//        request.httpBody = formData
//
//        perform(request: request, completion: completion)
//    }
//
//    // MARK: - Perform Request
//    private func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
//        session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                return completion(.failure(error))
//            }
//
//            guard let data = data else {
//                return completion(.failure(NSError(domain: "No data", code: -1)))
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decoded))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    // MARK: - Multipart Creator
//    private func createMultipartBody(boundary: String, media: Data, mediaFilename: String, messageId: String, replyId: String, text: String, time: String) -> Data {
//        var body = Data()
//
//        func appendFormField(_ name: String, value: String) {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//        }
//
//        func appendFileField(_ name: String, filename: String, data: Data, mimeType: String) {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//            body.append(data)
//            body.append("\r\n".data(using: .utf8)!)
//        }
//
//        appendFileField("media", filename: mediaFilename, data: media, mimeType: "image/jpeg")
//        appendFormField("message_id", value: messageId)
//        appendFormField("reply_id", value: replyId)
//        appendFormField("text", value: text)
//        appendFormField("time", value: time)
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//
//        return body
//    }
//}
