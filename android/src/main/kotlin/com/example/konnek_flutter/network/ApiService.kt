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
    @GET("channel/config/{clientId}/web")
    suspend fun getConfig(
        @Path("clientId") clientId: String
    ): Response<GetConfigResponseModel>

    // GET - Get Chat Conversation
//    @GET("room/conversation/{roomId}?page={currentPage}&limit={limit}&session_id={sessionId}")
    @GET("room/conversation/{roomId}")
    suspend fun getConversation(
        @Path("roomId") roomId: String,
        @Query("currentPage") currentPage: String,
        @Query("limit") limit: String,
        @Query("sessionId") sessionId: String,
        @Header("Authorization") token: String,
    ): Response<GetConversationResponseModel>

    // POST - Send Chat
    @POST("webhook/widget/{clientId}")
    suspend fun sendChat(
        @Path("clientId") clientId: String,
        @Body body: RequestBody,
//        @Body body: Map<*, *>,
//        @Field("name") name: String,
//        @Field("text") text: String? = null,
//        @Field("username") username: String,
    ): Response<SendChatResponseModel>

    // POST - Send Chat with Media
    @Multipart
    @POST("chat/media")
    // @Headers("Content-Type: multipart/form-data")
    suspend fun uploadMedia(
        @Part media: MultipartBody.Part,
        @Part("message_id") messageId: RequestBody,
        @Part("reply_id") replyId: RequestBody,
        @Part("text") text: RequestBody,
        @Part("time") time: RequestBody,
        @Header("Authorization") token: String,
        @Header("Access-Control-Allow-Origin") accessControlAllowOrigin: String? = "*",
    ): Response<UploadMediaResponseModel>


//    // GET - Fetch all items
//    @GET("posts")
//    suspend fun getPosts(): Response<List<Post>>
//
//    // GET - Fetch single item by ID
//    @GET("posts/{id}")
//    suspend fun getPostById(@Path("id") id: Int): Response<Post>
//
//    // GET - With query parameters
//    @GET("posts")
//    suspend fun getPostsByUserId(
//        @Query("userId") userId: Int,
//        @Query("_sort") sort: String = "id",
//        @Query("_order") order: String = "desc"
//    ): Response<List<Post>>
//
//    // POST - Create new item
//    @POST("posts")
//    suspend fun createPost(@Body post: Post): Response<Post>
//
//    // PUT - Update existing item
//    @PUT("posts/{id}")
//    suspend fun updatePost(
//        @Path("id") id: Int,
//        @Body post: Post
//    ): Response<Post>
//
//    // DELETE - Remove item
//    @DELETE("posts/{id}")
//    suspend fun deletePost(@Path("id") id: Int): Response<Unit>
//
//    // Example with custom headers
//    @Headers("Content-Type: application/json", "Accept: application/json")
//    @POST("auth/login")
//    suspend fun login(@Body credentials: Map<String, String>): Response<ApiResponse<String>>
}