package com.example.spam_filter

import android.app.Service
import android.content.Intent
import android.os.IBinder

class QuickResponseService : Service() {
    override fun onBind(arg0: Intent): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent, flags: Int, startID: Int): Int {
        return super.onStartCommand(intent, flags, startID)
    }
}