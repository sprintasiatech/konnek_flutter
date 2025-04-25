package com.example.konnek_flutter

import com.example.konnek_flutter.network.ApiConfig
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.File

class KonnekService {
    val gson = Gson()

    fun getConfig(
        call: MethodCall,
        onSuccess: (data: String) -> Unit?,
        onFailed: (errorMessage: String) -> Unit?,
    ) {
        try {
            val map: Map<*, *> = call.arguments as Map<*, *>
            val clientId: String? = map.get("clientId") as String?
            val platform: String? = map.get("platform") as String?

            if (clientId == null && platform == null) {
                onFailed.invoke("empty params")
                return
            }

            KonnekFlutterPlugin.clientId = clientId ?: ""

            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiConfig.provideApiService()
                val response = apiService.getConfig(
                    clientId ?: "",
                    platform = platform ?: "",
                )
//                println("[getConfig] response: $response")
                if (response.isSuccessful) {
                    val data = response.body()
                    val json: String = gson.toJson(data)
//                    println("[getConfig] json: $json")
                    onSuccess.invoke(json)
                } else {
                    onFailed.invoke(response.message())
                }
            }
        } catch (e: Exception) {
            onFailed.invoke(e.toString())
            return
        }
    }

    fun getConversation(
        call: MethodCall,
        onSuccess: (data: String) -> Unit?,
        onFailed: (errorMessage: String) -> Unit?,
    ) {
        try {
            val map: Map<*, *> = call.arguments as Map<*, *>

            val limit: String? = map.get("limit") as String?
            val roomId: String? = map.get("roomId") as String?
            val currentPage: String? = map.get("currentPage") as String?
            val sessionId: String? = map.get("sessionId") as String?

            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiConfig.provideApiService()
                val response = apiService.getConversation(
                    roomId ?: "",
                    currentPage ?: "",
                    limit ?: "",
                    sessionId ?: "",
                    KonnekFlutterPlugin.access,
                )
                if (response.isSuccessful) {
                    val data = response.body()
                    val json: String = gson.toJson(data)
                    onSuccess(json)
                } else {
                    onFailed(response.message())
                }
            }
        } catch (e: Exception) {
            onFailed(e.toString())
            return;
        }
    }

    // Convert Map to RequestBody for JSON
    fun convertMapToJsonRequestBody(map: Map<String, Any>): RequestBody {
        val json = gson.toJson(map)  // Convert Map to JSON string
        return RequestBody.create(
            "application/json".toMediaTypeOrNull(),
            json
        )  // Create RequestBody
    }

    fun sendChat(
        call: MethodCall,
        onSuccess: (data: String) -> Unit?,
        onFailed: (errorMessage: String) -> Unit?,
    ) {
        try {
            val map: Map<*, *> = call.arguments as Map<*, *>

            val clientId = map.get("clientId") as String?
            val name: String? = map.get("name") as String?
            val text: String? = map.get("text") as String?
            val username: String? = map.get("username") as String?
            val platform: String? = map.get("platform") as String?

            if (
                clientId == null &&
                name == null &&
                username == null &&
                platform == null
            ) {
                onFailed.invoke("empty params")
                return
            }

            KonnekFlutterPlugin.clientId = clientId ?: ""

            val reqBody: Map<String, Any>
            if (text == null) {
                reqBody = mapOf<String, Any>(
                    "name" to name.toString(),
                    "username" to username.toString(),
                )
            } else {
                reqBody = mapOf<String, Any>(
                    "name" to name.toString(),
                    "text" to text,
                    "username" to username.toString(),
                )
            }

            val requestBody = convertMapToJsonRequestBody(reqBody)

            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiConfig.provideApiService()
                val response = apiService.sendChat(
                    KonnekFlutterPlugin.clientId,
                    platform = platform ?: "",
                    requestBody,
                )
                println("[sendChat] response: $response")
                if (response.isSuccessful) {
                    val data = response.body()
                    val json: String = gson.toJson(data)
                    println("[sendChat] json: $json")
                    KonnekFlutterPlugin.access = "${data?.data?.token}"
                    onSuccess(json)
                } else {
                    onFailed(response.message())
                }
            }
        } catch (e: Exception) {
            onFailed(e.toString())
            return
        }
    }

    fun uploadMedia(
        call: MethodCall,
        onSuccess: (data: String) -> Unit?,
        onFailed: (errorMessage: String) -> Unit?,
    ) {
        try {
            val map: Map<*, *> = call.arguments as Map<*, *>
            println("map uploadMedia: $map")

            val fileData: String? = map.get("fileData") as String?
            val messageId: String? = map.get("messageId") as String?
            val replyId: String? = map.get("replyId") as String?
            val text: String? = map.get("text") as String?
            val time: String? = map.get("time") as String?

            val file = File(fileData ?: "")
            if (file.exists()) {
                // Do something with the file
                println("Received file: ${file.absolutePath}")
                println("Received ${file.name}")
            } else {
                onFailed("FILE NOT FOUND")
            }
            val apiService = ApiConfig.provideApiService()
            val requestImageFile = file.asRequestBody("multipart/form-data".toMediaType())
            val multipartBodyData = MultipartBody.Part.createFormData(
                "media",
                file.name,
                requestImageFile
            )

            CoroutineScope(Dispatchers.IO).launch {
                val response = apiService.uploadMedia(
                    media = multipartBodyData,
                    messageId = messageId!!.toRequestBody("text/plain".toMediaType()),
                    replyId = replyId!!.toRequestBody("text/plain".toMediaType()),
                    text = text!!.toRequestBody("text/plain".toMediaType()),
                    time = time!!.toRequestBody("text/plain".toMediaType()),
                    KonnekFlutterPlugin.access,
                    null,
                )
                if (response.isSuccessful) {
                    val data = response.body()
                    val json: String = gson.toJson(data)
                    onSuccess(json)
                } else {
                    onFailed(response.message())
                }
            }
        } catch (e: Exception) {
            onFailed(e.toString())
            return
        }
    }
}