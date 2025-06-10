package com.example.konnek_flutter.network

enum class Flavor {
    DEVELOPMENT,
    STAGING,
    PRODUCTION
}

object EnvironmentConfig {

    var flavor: Flavor = Flavor.STAGING
    private var _baseUrl: String = ""

    var customBaseUrl: String
        get() {
            return if (_baseUrl.isEmpty()) {
                when (flavor) {
                    Flavor.DEVELOPMENT -> "http://192.168.1.74:8080/"
                    Flavor.STAGING -> "https://stg.wekonnek.id:9443/"
                    Flavor.PRODUCTION -> "https://wekonnek.id:9443/"
                }
            } else {
                _baseUrl
            }
        }
        set(value) {
            _baseUrl = value
        }

    fun baseUrl(): String {
        return customBaseUrl
    }

    private var _baseUrlSocket: String = ""
    var customBaseUrlSocket: String
        get() {
            return if (_baseUrlSocket.isEmpty()) {
                when (flavor) {
                    Flavor.DEVELOPMENT -> "http://192.168.1.74:3000/"
                    Flavor.STAGING -> "https://stgsck.wekonnek.id:3001/"
                    Flavor.PRODUCTION -> "https://sck.wekonnek.id:3001/"
                }
            } else {
                _baseUrlSocket
            }
        }
        set(value) {
            _baseUrlSocket = value
        }

    fun baseUrlSocket(): String {
        return customBaseUrlSocket
    }
}
