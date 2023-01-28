package com.example.spam_filter

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.provider.BlockedNumberContract
import android.provider.Settings
import android.provider.Telephony
import android.widget.Toast

class Block(private val context: Context) {

    // Returns true or false if set as default sms app
    fun isDefault(): Boolean {
        return this.context.packageName.equals(Telephony.Sms.getDefaultSmsPackage(this.context))
    }

    // Opens settings to set as default sms app
    fun setDefault(): Boolean {
        return if (isDefault()) {
            true
        } else {
            Toast.makeText(context, "This feature requires app to be set as Default SMS App!", Toast.LENGTH_SHORT).show()
            Toast.makeText(context,"Settings Opened. Please set the Spam Filter App as default SMS App.", Toast.LENGTH_LONG).show()
            context.startActivity(Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS))
            false
        }
    }

    // returns list of blocked numbers
    fun getBlockedNumbers(): List<String> {
        val blockedNumbers = mutableListOf<String>()
        return if (isDefault()) {
            val blockedNumberCursor = context.contentResolver.query(
                BlockedNumberContract.BlockedNumbers.CONTENT_URI, arrayOf(
                    BlockedNumberContract.BlockedNumbers.COLUMN_ID,
                    BlockedNumberContract.BlockedNumbers.COLUMN_ORIGINAL_NUMBER,
                    BlockedNumberContract.BlockedNumbers.COLUMN_E164_NUMBER
                ), null, null, null
            )
            if (blockedNumberCursor != null) {
                while (blockedNumberCursor.moveToNext()) {
                    blockedNumbers.add(blockedNumberCursor.getString(1).toString())
                }
                blockedNumberCursor.close()
            }
            blockedNumbers.toList()
        } else {
            blockedNumbers.toList()
        }
    }

    // Checks if number is blocked
    private fun isBlocked(arguments: String): Boolean {
        if (isDefault()) {
            return BlockedNumberContract.isBlocked(this.context, arguments)
        }
        return false
    }

    // Blocks the specified number
    fun blockNumber(arguments: String, values: ContentValues) {
        if (isDefault() && !isBlocked(arguments)) {
            values.put(BlockedNumberContract.BlockedNumbers.COLUMN_ORIGINAL_NUMBER, arguments)
            this.context.contentResolver.insert(BlockedNumberContract.BlockedNumbers.CONTENT_URI, values)
        }
    }
}