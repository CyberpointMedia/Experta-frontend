# Keep all classes and members for WebRTC library
-keep class org.webrtc.** { *; }

# Keep all classes and members for Socket.IO library
-keep class io.socket.** { *; }

# Keep all classes and members for PeerJS library
-keep class org.peerjs.** { *; }

-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}