package com.mt.mtrecorder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler

private var eventSink: EventSink? = null

class NotificationReceiver : BroadcastReceiver(), StreamHandler {

    override fun onReceive(context: Context, intent: Intent) {

        val action = intent.action
        if (action != null) {
            when (action) {
                "record" -> {
                    eventSink?.success(action)

                }

                "ss" -> {
                    eventSink?.success(action)

                }

                "tools" -> {
                    eventSink?.success(action)

                }

                "home" -> {
                    eventSink?.success(action)

                }

                "exit" -> {
                    val notificationManager = NotificationManagerCompat.from(context)
                    notificationManager.cancel(100)
                }

                else -> {
                    eventSink?.error("action", "Unknown Action", "$action")
                }
            }
        }

    }


    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}