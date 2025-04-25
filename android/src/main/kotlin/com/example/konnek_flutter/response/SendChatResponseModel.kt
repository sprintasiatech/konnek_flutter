package com.example.konnek_flutter.response

import kotlinx.parcelize.Parcelize
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.RawValue

@Parcelize
data class SendChatResponseModel(

	@field:SerializedName("data")
	val data: DataSendChat? = null,

	@field:SerializedName("meta")
	val meta: MetaSendChat? = null
) : Parcelable

@Parcelize
data class DataSendChat(

	@field:SerializedName("expire")
	val expire: String? = null,

	@field:SerializedName("session_id")
	val sessionId: String? = null,

	@field:SerializedName("tid")
	val tid: String? = null,

	@field:SerializedName("token")
	val token: String? = null
) : Parcelable

@Parcelize
data class MetaSendChat(

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
