package com.example.konnek_flutter.response

import kotlinx.parcelize.Parcelize
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.RawValue

@Parcelize
data class GetConfigResponseModel(

	@field:SerializedName("data")
	val data: DataGetConfig? = null,

	@field:SerializedName("meta")
	val meta: MetaGetConfig? = null
) : Parcelable

@Parcelize
data class DataGetConfig(

	@field:SerializedName("preview")
	val preview: String? = null,

	@field:SerializedName("background_status")
	val backgroundStatus: String? = null,

	@field:SerializedName("ios_icon")
	val widgetIcon: String? = null,

	@field:SerializedName("company_id")
	val companyId: String? = null,

	@field:SerializedName("header_text_color")
	val headerTextColor: String? = null,

	@field:SerializedName("text_button_color")
	val textButtonColor: String? = null,

	@field:SerializedName("avatar_image")
	val avatarImage: String? = null,

	@field:SerializedName("text_button")
	val textButton: String? = null,

	@field:SerializedName("header_background_color")
	val headerBackgroundColor: String? = null,

	@field:SerializedName("button_color")
	val buttonColor: String? = null,

	@field:SerializedName("greeting_message")
	val greetingMessage: String? = null,

	@field:SerializedName("background")
	val background: String? = null,

	@field:SerializedName("avatar_name")
	val avatarName: String? = null,

	@field:SerializedName("status")
	val status: Boolean? = null,

	@field:SerializedName("text_status")
	val textStatus: Boolean? = null
) : Parcelable

@Parcelize
data class MetaGetConfig(

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
