package com.example.spam_filter

import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.telephony.SmsMessage
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MMSReceiver : BroadcastReceiver() {
    @OptIn(DelicateCoroutinesApi::class)
    override fun onReceive(context: Context, intent: Intent) {
        val intentExtras = intent.extras
        if (intent.action == "android.provider.Telephony.SMS_RECEIVED") {
            if (intentExtras != null) {
                val sms = intentExtras["pdus"] as Array<*>?
                if (sms != null) {
                    val smsMessage: SmsMessage = SmsMessage.createFromPdu(sms[0] as ByteArray, intentExtras.getString("format"))
                    val timestamp = smsMessage.timestampMillis.toString()
                    val sender = smsMessage.originatingAddress.toString()
                    val text = smsMessage.messageBody.toString()

                    // Logic for notifications, blocking, deleting
                    if (Block(context).isDefault()) {
                        // Global Scope for async tasks
                        GlobalScope.launch {
                            // Check number is in whitelist
                            val isWhitelisted = Settings(context).getListMap("whiteList").containsKey(sender)
                            if (!isWhitelisted) {
                                // Check if auto-block and auto-delete is on
                                val isBlockEnabled = Settings(context).getSetting(mutableListOf("auto-block", "false")) == "true"
                                val isDeleteEnabled = Settings(context).getSetting(mutableListOf("auto-delete", "false")) == "true"
                                if (isBlockEnabled || isDeleteEnabled) {
                                    val modelOutput = Model(context).prediction(listOf(text)).toString()
                                    val prediction = modelOutput.substring(1, modelOutput.length - 1).toDouble()
                                    val threshold = Settings(context).getSetting(mutableListOf("qualifier", "50")).toDouble()

                                    // Block and/or Delete if prediction is sufficient
                                    if (prediction > threshold) {
                                        if (isBlockEnabled && isDeleteEnabled) {
                                            // True: Block & Delete <-> Check: Notify
                                            Block(context).blockNumber(sender, ContentValues())
                                            Notification(context).sendNotification(sender, "Blocked & Deleted")
                                        } else if (isBlockEnabled) {
                                            // True: Block <-> False: Delete <-> Check: Notify
                                            if (Settings(context).saveMessages(mutableListOf(sender, text, timestamp, "false")) == "true") {
                                                Block(context).blockNumber(sender, ContentValues())
                                                Notification(context).sendNotification(sender, "Blocked", )
                                            }
                                        } else if (isDeleteEnabled) {
                                            // True: Delete <-> False: Block <-> Check: Notify
                                            Notification(context).sendNotification(sender, "Deleted")
                                        }
                                    } else {
                                        // Prediction is below threshold <-> Save & Notify
                                        if (Settings(context).saveMessages(mutableListOf(sender, text, timestamp, "false")) == "true") {
                                            Notification(context).sendNotification(sender, text)
                                        }
                                    }
                                }
                                else {
                                    // False: Block & Delete <-> Save & Notify
                                    if (Settings(context).saveMessages(mutableListOf(sender, text, timestamp, "false")) == "true") {
                                        Notification(context).sendNotification(sender, text)
                                    }
                                }
                            }
                            else {
                                // If in whitelist <-> Save & Notify
                                if (Settings(context).saveMessages(mutableListOf(sender, text, timestamp, "false")) == "true") {
                                    Notification(context).sendNotification(sender, text)
                                }
                            }
                        }
                    } else {
                        Settings(context).saveMessages(mutableListOf(sender, text, timestamp, "false"))
                    }
                }
            }
        }
    }
}