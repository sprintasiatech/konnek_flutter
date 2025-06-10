package com.example.konnek_flutter.response

import kotlinx.parcelize.Parcelize
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.RawValue

@Parcelize
data class UploadMediaResponseModel(

	@field:SerializedName("data")
	val data: DataUploadMedia? = null,

	@field:SerializedName("meta")
	val meta: MetaUploadMedia? = null
) : Parcelable

@Parcelize
data class DataUploadMedia(

	@field:SerializedName("reply_token")
	val replyToken: String? = null,

	@field:SerializedName("agent")
	val agent: AgentUploadMedia? = null,

	@field:SerializedName("company_id")
	val companyId: String? = null,

	@field:SerializedName("session")
	val session: SessionUploadMedia? = null,

	@field:SerializedName("provider_message_id")
	val providerMessageId: String? = null,

	@field:SerializedName("message_id")
	val messageId: String? = null,

	@field:SerializedName("channel_code")
	val channelCode: String? = null,

	@field:SerializedName("message")
	val message: MessageUploadMedia? = null,

	@field:SerializedName("error")
	val error: @RawValue Any? = null,

	@field:SerializedName("csat")
	val csat: @RawValue Any? = null,

	@field:SerializedName("reply_id")
	val replyId: String? = null,

	@field:SerializedName("republish")
	val republish: Int? = null,

	@field:SerializedName("company")
	val company: CompanyUploadMedia? = null,

	@field:SerializedName("from")
	val from: FromUploadMedia? = null,

	@field:SerializedName("prev_session")
	val prevSession: PrevSessionUploadMedia? = null,

	@field:SerializedName("customer")
	val customer: CustomerUploadMedia? = null
) : Parcelable

@Parcelize
data class MessageUploadMedia(

	@field:SerializedName("from_type")
	val fromType: String? = null,

	@field:SerializedName("template")
	val template: @RawValue Any? = null,

	@field:SerializedName("postback")
	val postback: PostbackUploadMedia? = null,

	@field:SerializedName("footer")
	val footer: @RawValue Any? = null,

	@field:SerializedName("interactive")
	val interactive: @RawValue Any? = null,

	@field:SerializedName("retry_time")
	val retryTime: @RawValue Any? = null,

	@field:SerializedName("media")
	val media: MediaUploadMedia? = null,

	@field:SerializedName("type")
	val type: String? = null,

	@field:SerializedName("retry_sending")
	val retrySending: Int? = null,

	@field:SerializedName("unix_msg_time")
	val unixMsgTime: Int? = null,

	@field:SerializedName("payload")
	val payload: String? = null,

	@field:SerializedName("received_at")
	val receivedAt: String? = null,

	@field:SerializedName("processed_at")
	val processedAt: @RawValue Any? = null,

	@field:SerializedName("header")
	val header: @RawValue Any? = null,

	@field:SerializedName("location")
	val location: LocationUploadMedia? = null,

	@field:SerializedName("template_id")
	val templateId: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("time")
	val time: String? = null,

	@field:SerializedName("text")
	val text: String? = null
) : Parcelable

@Parcelize
data class MediaUploadMedia(

	@field:SerializedName("size")
	val size: Int? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("url")
	val url: String? = null
) : Parcelable

@Parcelize
data class AgentUploadMedia(

	@field:SerializedName("priority_level_id")
	val priorityLevelId: String? = null,

	@field:SerializedName("priority_level_name")
	val priorityLevelName: String? = null,

	@field:SerializedName("user_id")
	val userId: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("contact_id")
	val contactId: String? = null,

	@field:SerializedName("username")
	val username: String? = null
) : Parcelable

@Parcelize
data class CustomerUploadMedia(

	@field:SerializedName("priority_level_id")
	val priorityLevelId: String? = null,

	@field:SerializedName("priority_level_name")
	val priorityLevelName: String? = null,

	@field:SerializedName("user_id")
	val userId: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("contact_id")
	val contactId: String? = null,

	@field:SerializedName("username")
	val username: String? = null
) : Parcelable

@Parcelize
data class MetaUploadMedia(

	@field:SerializedName("log_id")
	val logId: String? = null,

	@field:SerializedName("code")
	val code: Int? = null,

	@field:SerializedName("message")
	val message: String? = null,

	@field:SerializedName("errors")
	val errors: @RawValue Any? = null,

	@field:SerializedName("status")
	val status: Boolean? = null
) : Parcelable

@Parcelize
data class CompanyUploadMedia(

	@field:SerializedName("code")
	val code: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("status")
	val status: Boolean? = null
) : Parcelable

@Parcelize
data class LocationUploadMedia(

	@field:SerializedName("address")
	val address: String? = null,

	@field:SerializedName("live_period")
	val livePeriod: Int? = null,

	@field:SerializedName("latitude")
	val latitude: Int? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("longitude")
	val longitude: Int? = null
) : Parcelable

@Parcelize
data class FromUploadMedia(

	@field:SerializedName("priority_level_id")
	val priorityLevelId: String? = null,

	@field:SerializedName("priority_level_name")
	val priorityLevelName: String? = null,

	@field:SerializedName("user_id")
	val userId: String? = null,

	@field:SerializedName("name")
	val name: String? = null,

	@field:SerializedName("description")
	val description: String? = null,

	@field:SerializedName("avatar")
	val avatar: String? = null,

	@field:SerializedName("contact_id")
	val contactId: String? = null,

	@field:SerializedName("username")
	val username: String? = null
) : Parcelable

@Parcelize
data class SessionUploadMedia(

	@field:SerializedName("room_id")
	val roomId: String? = null,

	@field:SerializedName("sla_status")
	val slaStatus: String? = null,

	@field:SerializedName("last_customer_message_time")
	val lastCustomerMessageTime: @RawValue Any? = null,

	@field:SerializedName("open_time")
	val openTime: @RawValue Any? = null,

	@field:SerializedName("sla_threshold")
	val slaThreshold: Int? = null,

	@field:SerializedName("unix_open_time")
	val unixOpenTime: Int? = null,

	@field:SerializedName("sla_from")
	val slaFrom: String? = null,

	@field:SerializedName("open_by")
	val openBy: String? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("categories")
	val categories: String? = null,

	@field:SerializedName("assign_time")
	val assignTime: @RawValue Any? = null,

	@field:SerializedName("unix_que_time")
	val unixQueTime: Int? = null,

	@field:SerializedName("close_by")
	val closeBy: String? = null,

	@field:SerializedName("handover_by")
	val handoverBy: String? = null,

	@field:SerializedName("unix_assign_time")
	val unixAssignTime: Int? = null,

	@field:SerializedName("last_agent_chat_time")
	val lastAgentChatTime: @RawValue Any? = null,

	@field:SerializedName("bot_status")
	val botStatus: Boolean? = null,

	@field:SerializedName("is_new")
	val isNew: Boolean? = null,

	@field:SerializedName("division_id")
	val divisionId: String? = null,

	@field:SerializedName("close_time")
	val closeTime: @RawValue Any? = null,

	@field:SerializedName("sla_to")
	val slaTo: String? = null,

	@field:SerializedName("queue_time")
	val queueTime: @RawValue Any? = null,

	@field:SerializedName("first_response_time")
	val firstResponseTime: @RawValue Any? = null,

	@field:SerializedName("sla_durations")
	val slaDurations: Int? = null,

	@field:SerializedName("session_priority_level_id")
	val sessionPriorityLevelId: String? = null,

	@field:SerializedName("status")
	val status: Int? = null
) : Parcelable

@Parcelize
data class PostbackUploadMedia(

	@field:SerializedName("type")
	val type: String? = null,

	@field:SerializedName("title")
	val title: String? = null,

	@field:SerializedName("value")
	val value: String? = null,

	@field:SerializedName("key")
	val key: String? = null
) : Parcelable

@Parcelize
data class PrevSessionUploadMedia(

	@field:SerializedName("open_time")
	val openTime: @RawValue Any? = null,

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("unix_open_time")
	val unixOpenTime: Int? = null
) : Parcelable
