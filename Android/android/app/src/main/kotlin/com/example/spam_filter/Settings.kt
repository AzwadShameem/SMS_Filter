package com.example.spam_filter

import android.Manifest
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.pm.PackageManager
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class Settings(private val context: Context) {

    // Sends Message
    fun sendMessage(arguments: List<*>): String {
        SmsManager.getDefault().sendTextMessage(arguments[0] as String, null, arguments[1] as String, null, null)
        return "true"
    }

    // Saves messages in Android cache
     fun saveMessages(arguments: List<*>): String {
        val messages: MutableList<List<String>> = loadMessages().toMutableList()
        messages.add(arguments as List<String>)
        context.getSharedPreferences("Settings", MODE_PRIVATE).edit().putString("messages", Gson().toJson(messages)).apply()
        return "true"
    }

    // Loads messages from Android cache
    fun loadMessages(): List<List<String>> {
        return if (context.getSharedPreferences("Settings", MODE_PRIVATE).getString("messages", "").isNullOrEmpty()) {
            listOf()
        } else {
            Gson().fromJson(context.getSharedPreferences("Settings", MODE_PRIVATE).getString("messages", ""), object : TypeToken<List<List<String>>>() {}.type)
        }
    }

    fun setSetting(arguments: List<*>): String {
        context.getSharedPreferences("Settings", MODE_PRIVATE).edit().putString(arguments[0] as String, arguments[1] as String).apply()
        return arguments[1] as String
    }

    fun getSetting(arguments: List<*>): String {
        return context.getSharedPreferences("Settings", MODE_PRIVATE).getString(arguments[0] as String, arguments[1] as String).toString()
    }

    suspend fun setListMap(arguments: List<*>): String {
        withContext(Dispatchers.Default) {
            val map = getListMap(arguments[0] as String)
            map[arguments[1] as String] = arguments[2] as Double
            context.getSharedPreferences("Settings", MODE_PRIVATE).edit().putString(arguments[0] as String, Gson().toJson(map)).apply()
        }
        return "true"
    }

    suspend fun getListMap(listName: String): HashMap<String, Double> {
        return withContext(Dispatchers.Default) {
            if (context.getSharedPreferences("Settings", MODE_PRIVATE).getString(listName, "").isNullOrEmpty()) {
                hashMapOf()
            } else {
                Gson().fromJson(context.getSharedPreferences("Settings", MODE_PRIVATE).getString(listName, ""), object : TypeToken<HashMap<String, Double>>() {}.type)
            }
        }
    }

    suspend fun removeListMap(arguments: List<*>): String {
        withContext(Dispatchers.Default) {
            val map = getListMap(arguments[0] as String)
            map.remove(arguments[1] as String)
            context.getSharedPreferences("Settings", MODE_PRIVATE).edit().putString(arguments[0] as String, Gson().toJson(map)).apply()
        }
        return "true"
    }
}