package com.mt.mtrecorder

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.util.Date
import kotlin.time.Duration.Companion.milliseconds


class MainActivity : FlutterActivity() {
    private val mChannel = "com.mt.mtrecorder/method_channel"
    private val eChannel = "com.mt.mtrecorder/event_channel"


    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eChannel)
            .setStreamHandler(NotificationReceiver())

        // Set up the method channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            mChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initNotification" -> {
                    showNotification()
                }

                "takeScreenshot" -> {
                    takeScreenshot()
                    // val screenshotBitmap = takeScreenshot()
                    //val imageByteArray = convertBitmapToByteArray(screenshotBitmap)
                    //result.success(screenshotBitmap)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun takeScreenshot() {
        val v: View = activity.window.decorView.rootView
        val now = Date().time.milliseconds
        v.setDrawingCacheEnabled(true)
        val b: Bitmap = v.getDrawingCache()
        val extr = Environment.getExternalStorageDirectory().toString()
        val myPath = Environment.getExternalStorageDirectory().toString() + "/" + now.toString()
        var fos: FileOutputStream? = null
        try {
            fos = FileOutputStream(myPath)
            b.compress(Bitmap.CompressFormat.JPEG, 100, fos)
            fos.flush()
            fos.close()
            MediaStore.Images.Media.insertImage(
                contentResolver, b,
                "Screen", "screen"
            )
        } catch (e: FileNotFoundException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        } catch (e: Exception) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        }
        /*  val now = Date().time.milliseconds
          // DateFormat.format("yyyy-MM-dd_hh:mm:ss", now)
          try {
              // image naming and path  to include sd card  appending name you choose for file
              val mPath = Environment.getExternalStorageDirectory().toString() + "/" + now.toString()
                  .replace(" ", "") + ".jpg"

              // create bitmap screen capture
              val v1: View = activity.window.decorView.rootView
              v1.isDrawingCacheEnabled = true
              val bitmap = Bitmap.createBitmap(v1.drawingCache)
              v1.isDrawingCacheEnabled = false
              val imageFile = File(mPath)
              val outputStream = FileOutputStream(imageFile)
              val quality = 100
              bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream)
              outputStream.flush()
              outputStream.close()
              println("this is the path -->")
              println(imageFile.absolutePath)
              openScreenshot(imageFile)
          } catch (e: Throwable) {
              // Several error may come out with file handling or DOM
              e.printStackTrace()
          }*/
    }

    private fun openScreenshot(imageFile: File) {
        val intent = Intent()
        intent.action = Intent.ACTION_VIEW
        val uri = Uri.fromFile(imageFile)
        intent.setDataAndType(uri, "image/*")
        startActivity(intent)
    }

    private fun convertBitmapToByteArray(bitmap: Bitmap): ByteArray {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun showNotification() {

        val collapsedView = RemoteViews(
            packageName,
            R.layout.notification_collapsed
        )


        val myPermission: Array<String> = arrayOf(Manifest.permission.POST_NOTIFICATIONS)
        ActivityCompat.requestPermissions(this, myPermission, 1)
        val intent = Intent(context, MainActivity::class.java)
        val contentIntent =
            PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)


        val clickIntent1 = Intent(this, NotificationReceiver::class.java).apply {
            action = "record"
            putExtra(Notification.EXTRA_NOTIFICATION_ID, 0)
        }
        val btnPendingIntent1: PendingIntent =
            PendingIntent.getBroadcast(this, 0, clickIntent1, PendingIntent.FLAG_IMMUTABLE)

        val clickIntent2 = Intent(this, NotificationReceiver::class.java).apply {
            action = "ss"
            putExtra(Notification.EXTRA_NOTIFICATION_ID, 0)
        }
        val btnPendingIntent2: PendingIntent =
            PendingIntent.getBroadcast(this, 0, clickIntent2, PendingIntent.FLAG_IMMUTABLE)


        val clickIntent3 = Intent(this, NotificationReceiver::class.java).apply {
            action = "home"
            putExtra(Notification.EXTRA_NOTIFICATION_ID, 0)
        }
        val btnPendingIntent3: PendingIntent =
            PendingIntent.getBroadcast(this, 0, clickIntent3, PendingIntent.FLAG_IMMUTABLE)

        val clickIntent4 = Intent(this, NotificationReceiver::class.java).apply {
            action = "tools"
            putExtra(Notification.EXTRA_NOTIFICATION_ID, 0)
        }

        val btnPendingIntent4: PendingIntent =
            PendingIntent.getBroadcast(this, 0, clickIntent4, PendingIntent.FLAG_IMMUTABLE)

        val clickIntent5 = Intent(this, NotificationReceiver::class.java).apply {
            action = "exit"
            putExtra(Notification.EXTRA_NOTIFICATION_ID, 0)
        }

        val btnPendingIntent5: PendingIntent =
            PendingIntent.getBroadcast(this, 0, clickIntent5, PendingIntent.FLAG_IMMUTABLE)

        collapsedView.setOnClickPendingIntent(R.id.llRecord, btnPendingIntent1)
        collapsedView.setOnClickPendingIntent(R.id.llSs, btnPendingIntent2)
        collapsedView.setOnClickPendingIntent(R.id.llHome, btnPendingIntent3)
        collapsedView.setOnClickPendingIntent(R.id.llTools, btnPendingIntent4)
        collapsedView.setOnClickPendingIntent(R.id.llExit, btnPendingIntent5)
      //  val color = 0x008000
        val builder = NotificationCompat.Builder(this, "CHANNEL_ID")
            .setSmallIcon(R.drawable.icon_png).setContentTitle("")

            .setCustomBigContentView(collapsedView)
            .setContent(collapsedView)
            .setContentIntent(contentIntent)
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()


        /*  val newVar = NotificationCompat.Builder(this, "CHANNEL_ID")
              .setSmallIcon(R.drawable.ic_launcher)
              .setContentTitle("")*/


        /*  NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this);

          notificationBuilder.setSmallIcon(getNotificationIcon(notificationBuilder));

          private int getNotificationIcon(NotificationCompat.Builder notificationBuilder) {

              if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                  int color = 0x008000;
                  notificationBuilder.setColor(color);
                  return R.drawable.app_icon_lolipop_above;

              }
              return R.drawable.app_icon_lolipop_below;
          }

  */


        val notificationManager: NotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel("CHANNEL_ID", title, importance).apply {
                description = "content"
            }
            // Register the channel with the system

            notificationManager.createNotificationChannel(channel)
        }
        notificationManager.notify(100, builder)

    }


}
