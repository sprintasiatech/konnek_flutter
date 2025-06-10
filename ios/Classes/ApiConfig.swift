//import Foundation
//
//class ApiConfig {
//    static let shared = ApiConfig()
//    
//    private let baseUrl = EnvironmentConfig.baseURL
//    private let session: URLSession
//    
//    private init() {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 120
//        config.timeoutIntervalForResource = 120
//        
//        // Attach logging if needed
//        config.protocolClasses = [LoggingURLProtocol.self] + (config.protocolClasses ?? [])
//        
//        self.session = URLSession(configuration: config)
//    }
//    
//    func provideApiService() -> ApiService {
//        return ApiService(session: session, baseUrl: baseUrl)
//    }
//}
