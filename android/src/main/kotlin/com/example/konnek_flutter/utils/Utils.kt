package com.example.konnek_flutter.utils

import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

private const val FILENAME_FORMAT = "yyyyMMdd_HHmmss"

//private const val MAXIMAL_SIZE = 1000000
private const val MAXIMAL_SIZE = 500000
private val timeStamp: String = SimpleDateFormat(FILENAME_FORMAT, Locale.US).format(Date())

//    fun getImageUri(context: Context): Uri {
//        var uri: Uri? = null
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            val contentValues = ContentValues().apply {
//                put(MediaStore.MediaColumns.DISPLAY_NAME, "$timeStamp.jpg")
//                put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
//                put(MediaStore.MediaColumns.RELATIVE_PATH, "Pictures/MyCamera/")
//            }
//            uri = context.contentResolver.insert(
//                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
//                contentValues
//            )
//        }
//        return uri ?: getImageUriForPreQ(context)
//    }

//    private fun getImageUriForPreQ(context: Context): Uri {
//        val filesDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
//        val imageFile = File(filesDir, "/MyCamera/$timeStamp.jpg")
//        if (imageFile.parentFile?.exists() == false) imageFile.parentFile?.mkdir()
//        return FileProvider.getUriForFile(
//            context,
//            "${BuildConfig.APPLICATION_ID}.fileprovider",
//            imageFile
//        )
//    }

fun localDateFormat(timestamp: String): String {
    val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
    val date = sdf.parse(timestamp) as Date

    val formattedDate = DateFormat.getDateInstance(DateFormat.FULL).format(date)
    return formattedDate
}

fun createCustomTempFile(context: Context): File {
    val filesDir = context.externalCacheDir
    return File.createTempFile(timeStamp, ".jpg", filesDir)
}

fun uriToFile(imageUri: Uri, context: Context): File {
    val myFile = createCustomTempFile(context)
    val inputStream = context.contentResolver.openInputStream(imageUri) as InputStream
    val outputStream = FileOutputStream(myFile)
    val buffer = ByteArray(1024)
    var length: Int
    while (inputStream.read(buffer).also { length = it } > 0) outputStream.write(
        buffer,
        0,
        length
    )
    outputStream.close()
    inputStream.close()
    return myFile
}

@RequiresApi(Build.VERSION_CODES.Q)
fun File.reduceFileImage(): File? {
    val file = this
    val bitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        BitmapFactory.decodeFile(file.path).getRotatedBitmap(file)
    } else {
        return null
    }

    var compressQuality = 100
    var streamLength: Int
    do {
        val bmpStream = ByteArrayOutputStream()
        bitmap?.compress(Bitmap.CompressFormat.JPEG, compressQuality, bmpStream)
        val bmpPicByteArray = bmpStream.toByteArray()
        streamLength = bmpPicByteArray.size
        compressQuality -= 5
    } while (streamLength > MAXIMAL_SIZE)
    bitmap?.compress(Bitmap.CompressFormat.JPEG, compressQuality, FileOutputStream(file))

    return file
}

@RequiresApi(Build.VERSION_CODES.Q)
fun Bitmap.getRotatedBitmap(file: File): Bitmap? {
    val orientation = ExifInterface(file).getAttributeInt(
        ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED,
    )
    return when (orientation) {
        ExifInterface.ORIENTATION_ROTATE_90 -> rotateImage(this, 90F)
        ExifInterface.ORIENTATION_ROTATE_180 -> rotateImage(this, 180F)
        ExifInterface.ORIENTATION_ROTATE_270 -> rotateImage(this, 270F)
        ExifInterface.ORIENTATION_NORMAL -> this
        else -> this
    }
}

fun rotateImage(source: Bitmap, angle: Float): Bitmap? {
    val matrix = Matrix()
    matrix.postRotate(angle)
    return Bitmap.createBitmap(
        source, 0, 0, source.width, source.height, matrix, true
    )
}


