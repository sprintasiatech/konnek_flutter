package com.example.konnek_flutter.network

import com.example.konnek_flutter.response.GetConfigResponseModel
import com.example.konnek_flutter.response.GetConversationResponseModel
import com.example.konnek_flutter.response.SendChatResponseModel
import com.example.konnek_flutter.response.UploadMediaResponseModel
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    // GET - Get Config
    @GET("channel/config/{clientId}/{platform}")
    suspend fun getConfig(
        @Path("clientId") clientId: String,
        @Path("platform") platform: String,
    ): Response<GetConfigResponseModel>

    // GET - Get Chat Conversation
    @GET("room/conversation/{roomId}")
    suspend fun getConversation(
        @Path("roomId") roomId: String,
        @Query("page") currentPage: String,
        @Query("limit") limit: String,
        @Query("sessionId") sessionId: String,
        @Header("Authorization") token: String,
    ): Response<GetConversationResponseModel>

    // POST - Send Chat
    @POST("webhook/{platform}/{clientId}")
    suspend fun sendChat(
        @Path("clientId") clientId: String,
        @Path("platform") platform: String,
        @Body body: RequestBody,
    ): Response<SendChatResponseModel>

    // POST - Send Chat with Media
    @Multipart
    @POST("chat/media")
    suspend fun uploadMedia(
        @Part media: MultipartBody.Part,
        @Part("message_id") messageId: RequestBody,
        @Part("reply_id") replyId: RequestBody,
        @Part("text") text: RequestBody,
        @Part("time") time: RequestBody,
        @Header("Authorization") token: String,
        @Header("Access-Control-Allow-Origin") accessControlAllowOrigin: String? = "*",
    ): Response<UploadMediaResponseModel>
}