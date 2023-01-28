package com.example.spam_filter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class Notification(private val context: Context) {
    private val channel = "spam_filter_channel_id"

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Spam Filter"
            val descriptionText = "Notifications for Spam Filter"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(channel, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun sendNotification(contentTitle: String = "", contentDescription: String = "", notificationID: Int = 0) {
        if (Settings(context).getSetting(mutableListOf("notifications", "true")) == "true") {
            createNotificationChannel()

            val builder = NotificationCompat.Builder(context, channel)
                .setSmallIcon(R.drawable.ic_baseline_phone_in_talk_24)
                .setContentTitle(contentTitle)
                .setContentText(contentDescription)
                .setPriority(NotificationCompat.PRIORITY_HIGH)

            with(NotificationManagerCompat.from(context)) {
                notify(notificationID, builder.build())
            }
        }
    }
}
