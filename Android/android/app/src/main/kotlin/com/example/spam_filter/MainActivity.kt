package com.example.spam_filter

import android.Manifest
import android.R.attr.tag
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class MainActivity: FlutterActivity() {
    companion object {
        lateinit var flutterChannel: MethodChannel
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "Android")
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "Android").setMethodCallHandler { call, result ->
            if (call.method.equals("sendMessage")) {
                GlobalScope.launch {
                    result.success(Settings(context).sendMessage(call.arguments as List<*>))
                }
            } else if (call.method.equals("saveMessage")) {
                GlobalScope.launch {
                    result.success(Settings(context).saveMessages(call.arguments as List<*>))
                }
            } else if (call.method.equals("loadMessages")) {
                GlobalScope.launch {
                    result.success(Settings(context).loadMessages())
                }
            } else if(call.method.equals("getAssets")) {
                GlobalScope.launch {
                    result.success(Model(context).getAssets())
                }
            } else if (call.method.equals("prediction")) {
                GlobalScope.launch {
                    result.success(Model(context).prediction(call.arguments as List<*>))
                }
            } else if (call.method.equals("train")) {
                GlobalScope.launch {
                    result.success(Model(context).train(call.arguments as List<*>))
                }
            } else if (call.method.equals("reset")) {
                GlobalScope.launch {
                    result.success(Model(context).reset())
                }
            } else if (call.method.equals("setSettings")) {
                GlobalScope.launch {
                    result.success(Settings(context).setSetting(call.arguments as List<*>))
                }
            } else if (call.method.equals("getSettings")) {
                GlobalScope.launch {
                    result.success(Settings(context).getSetting(call.arguments as List<*>))
                }
            } else if (call.method.equals("setMap")) {
                GlobalScope.launch {
                    result.success(Settings(context).setListMap(call.arguments as List<*>))
                }
            }  else if (call.method.equals("getMap")) {
                GlobalScope.launch {
                    result.success(Settings(context).getListMap(call.arguments as String))
                }
            }  else if (call.method.equals("removeMap")) {
                GlobalScope.launch {
                    result.success(Settings(context).removeListMap(call.arguments as List<*>))
                }
            } else if (call.method.equals("isDefault")) {
                    result.success(Block(context).isDefault())
            } else if (call.method.equals("setDefault")) {
                    result.success(Block(context).setDefault())
            } else if (call.method.equals("getBlockedNumbers")) {
                    result.success(Block(context).getBlockedNumbers())
            } else {
                result.notImplemented()
            }
        }
    }
}