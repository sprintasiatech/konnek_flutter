package com.example.konnek_flutter.response

import kotlinx.parcelize.Parcelize
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.RawValue

@Parcelize
data class GetConversationResponseModel(

	@field:SerializedName("data")
	val data: DataGetConversation? = null,

	@field:SerializedName("meta")
	val meta: MetaGetConversation? = null
) : Parcelable

@Parcelize
data class AgentGetConversation(

	@field:SerializedName("online_status")
	val onlineStatus: Int? = null,

	@field:SerializedName("customer_channel")
	val customerChannel: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("tags")
	val tags: String? = null,

	@field:SerializedName("is_blocked")
	val isBlocked: Boolean? = null,

	@field:SerializedName("phone")
	val phone: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("email")
	val email: String? = null,

	@field:SerializedName("username")
	val username: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class CloseUserGetConversation(

	@field:SerializedName("online_status")
	val onlineStatus: Int? = null,

	@field:SerializedName("customer_channel")
	val customerChannel: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("tags")
	val tags: String? = null,

	@field:SerializedName("is_blocked")
	val isBlocked: Boolean? = null,

	@field:SerializedName("phone")
	val phone: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("email")
	val email: String? = null,

	@field:SerializedName("username")
	val username: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class SessionGetConversation(

	@field:SerializedName("room_id")
	val roomId: String? = null,

	@field:SerializedName("agent_user_id")
	val agentUserId: String? = null,

	@field:SerializedName("last_agent_chat_time")
	val lastAgentChatTime: String? = null,

	@field:SerializedName("agent")
	val agent: AgentGetConversation? = null,

	@field:SerializedName("bot_status")
	val botStatus: Boolean? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("open_time")
	val openTime: String? = null,

	@field:SerializedName("close_time")
	val closeTime: String? = null,

	@field:SerializedName("close_user")
	val closeUser: CloseUserGetConversation? = null,

	@field:SerializedName("queue_time")
	val queueTime: String? = null,

	@field:SerializedName("first_response_time")
	val firstResponseTime: String? = null,

	@field:SerializedName("session_priority_level_id")
	val sessionPriorityLevelId: String? = null,

	@field:SerializedName("open_by")
	val openBy: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("categories")
	val categories: String? = null,

	@field:SerializedName("assign_time")
	val assignTime: String? = null,

	@field:SerializedName("close_by")
	val closeBy: String? = null,

	@field:SerializedName("handover_by")
	val handoverBy: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class UserGetConversation(

	@field:SerializedName("online_status")
	val onlineStatus: Int? = null,

	@field:SerializedName("customer_channel")
	val customerChannel: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("tags")
	val tags: String? = null,

	@field:SerializedName("is_blocked")
	val isBlocked: Boolean? = null,

	@field:SerializedName("phone")
	val phone: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("email")
	val email: String? = null,

	@field:SerializedName("username")
	val username: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class DataGetConversation(

	@field:SerializedName("expire")
	val expire: String? = null,

	@field:SerializedName("conversations")
	val conversations: List<ConversationsItemGetConversation?>? = null,

	@field:SerializedName("room")
	val room: RoomGetConversation? = null,

	@field:SerializedName("token")
	val token: String? = null
) : Parcelable

@Parcelize
data class RoomGetConversation(

	@field:SerializedName("customer_description")
	val customerDescription: String? = null,

	@field:SerializedName("last_customer_message_time")
	val lastCustomerMessageTime: String? = null,

	@field:SerializedName("open_time")
	val openTime: String? = null,

	@field:SerializedName("channel_code")
	val channelCode: String? = null,

	@field:SerializedName("customer_username")
	val customerUsername: String? = null,

	@field:SerializedName("open_by")
	val openBy: String? = null,

	@field:SerializedName("assign_time")
	val assignTime: String? = null,

	@field:SerializedName("categories")
	val categories: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("close_by")
	val closeBy: String? = null,

	@field:SerializedName("handover_by")
	val handoverBy: String? = null,

	@field:SerializedName("agent_user_id")
	val agentUserId: String? = null,

	@field:SerializedName("last_agent_chat_time")
	val lastAgentChatTime: String? = null,

	@field:SerializedName("company_id")
	val companyId: String? = null,

	@field:SerializedName("bot_status")
	val botStatus: Boolean? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("session_id")
	val sessionId: String? = null,

	@field:SerializedName("send_outbound_flag")
	val sendOutboundFlag: Boolean? = null,

	@field:SerializedName("close_time")
	val closeTime: String? = null,

	@field:SerializedName("queue_time")
	val queueTime: String? = null,

	@field:SerializedName("customer_avatar")
	val customerAvatar: String? = null,

	@field:SerializedName("first_response_time")
	val firstResponseTime: String? = null,

	@field:SerializedName("customer_email")
	val customerEmail: String? = null,

	@field:SerializedName("customer_name")
	val customerName: String? = null,

	@field:SerializedName("customer_id")
	val customerId: String? = null,

	@field:SerializedName("window_messaging")
	val windowMessaging: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class MetaGetConversation(

	@field:SerializedName("next_page")
	val nextPage: Boolean? = null,

	@field:SerializedName("log_id")
	val logId: String? = null,

	@field:SerializedName("per_page")
	val perPage: Int? = null,

	@field:SerializedName("code")
	val code: Int? = null,

	@field:SerializedName("total_count")
	val totalCount: Int? = null,

	@field:SerializedName("message")
	val message: String? = null,

	@field:SerializedName("prev_page")
	val prevPage: Boolean? = null,

	@field:SerializedName("errors")
	val errors: @RawValue Any? = null,

	@field:SerializedName("current_page")
	val currentPage: Int? = null,

	@field:SerializedName("page_count")
	val pageCount: Int? = null,

	@field:SerializedName("status")
	val status: Boolean? = null
) : Parcelable

@Parcelize
data class ConversationsItemGetConversation(

	@field:SerializedName("room_id")
	val roomId: String? = null,

	@field:SerializedName("from_type")
	val fromType: String? = null,

	@field:SerializedName("session")
	val session: SessionGetConversation? = null,

	@field:SerializedName("session_id")
	val sessionId: String? = null,

	@field:SerializedName("created_at")
	val createdAt: String? = null,

	@field:SerializedName("message_id")
	val messageId: String? = null,

	@field:SerializedName("type")
	val type: String? = null,

	@field:SerializedName("created_by")
	val createdBy: String? = null,

	@field:SerializedName("message_time")
	val messageTime: String? = null,

	@field:SerializedName("reply_id")
	val replyId: String? = null,

	@field:SerializedName("user_id")
	val userId: String? = null,

	@field:SerializedName("payload")
	val payload: String? = null,

	@field:SerializedName("unix_msg_time")
	val unixMsgTime: Long? = null,

	@field:SerializedName("seq_id")
	val seqId: Int? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("text")
	val text: String? = null,

	@field:SerializedName("user")
	val user: UserGetConversation? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable
