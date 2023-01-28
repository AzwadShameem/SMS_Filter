package com.example.spam_filter

import android.content.Context
import com.chaquo.python.PyException
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import io.flutter.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream

class Model(private val context: Context) {

    // Loads NLTK in python
    suspend fun getAssets(): Boolean {
        return withContext(Dispatchers.IO) {
            if (!Python.isStarted()) {
                Python.start(AndroidPlatform(context))
            }
            return@withContext try {
                Python.getInstance().getModule("model").callAttr("getAssets")
                true
            } catch (e: PyException) {
                Log.e("Error", e.toString())
                false
            }
        }
    }

    // Runs model inference on a list of sms
    suspend fun prediction(arguments: List<*>): Any {
        return withContext(Dispatchers.IO) {
            if (!Python.isStarted()) {
                Python.start(AndroidPlatform(context))
            }
            return@withContext try {
                Python.getInstance().getModule("model").callAttr("predict", modelPath(context, "model.pt"), arguments.toTypedArray()).toJava(DoubleArray::class.java).toList()
            } catch (e: PyException) {
                Log.e("Error", e.toString())
            }
        }
    }

    fun getPrediction(arguments: List<*>): Any {
        if (!Python.isStarted()) {
            Python.start(AndroidPlatform(context))
        }
        return try {
            Python.getInstance().getModule("model").callAttr("predict", modelPath(context, "model.pt"), arguments.toTypedArray()).toJava(DoubleArray::class.java).toList()
        } catch (e: PyException) {
            Log.e("Error", e.toString())
        }
    }

    // Trains the model with a single sms
    suspend fun train(arguments: List<*>): String {
        return withContext(Dispatchers.IO) {
            if (!Python.isStarted()) {
                Python.start(AndroidPlatform(context))
            }
            return@withContext try {
                Python.getInstance().getModule("model").callAttr("train", modelPath(context, "model.pt"), arguments[0] as String, arguments[1] as Int, 1).toString()
            } catch (e: PyException) {
                Log.e("Error", e.toString())
                "-1"
            }
        }
    }

    // Resets the model to it's original state
    suspend fun reset(): String {
        return withContext(Dispatchers.IO) {
            if (!Python.isStarted()) {
                Python.start(AndroidPlatform(context))
            }
            return@withContext try {
                Python.getInstance().getModule("model").callAttr("reset", modelPath(context, "model.pt"), modelPath(context, "original.pt")).toString()
            } catch (e: PyException) {
                Log.e("Error", e.toString())
                "-1"
            }
        }
    }

    private fun modelPath(context: Context, name: String): String {
        val file = File(context.filesDir, name)
        if (file.exists() && file.length() > 0) {
            return file.absolutePath
        }
        context.assets.open(name).use { f ->
            FileOutputStream(file).use { os ->
                val buffer = ByteArray(4 * 1024)
                var read: Int
                while (f.read(buffer).also { read = it } != -1) {
                    os.write(buffer, 0, read)
                }
                os.flush()
            }
            return file.absolutePath
        }
    }
}
