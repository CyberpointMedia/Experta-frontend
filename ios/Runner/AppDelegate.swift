import Flutter
import UIKit
import ReplayKit
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let logger = OSLog(subsystem: "com.example.expert", category: "ScreenSharing")
    private var screenRecorder: RPScreenRecorder?
    private var isRecording: Bool = false
    private static let channelName = "com.example.expert/screen_sharing"
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        os_log("Application launching", log: logger, type: .info)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            os_log("Failed to get FlutterViewController", log: logger, type: .error)
            return false
        }
        setupScreenRecorder()
        setupMethodChannel(controller)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func setupScreenRecorder() {
        screenRecorder = RPScreenRecorder.shared()
        screenRecorder?.isMicrophoneEnabled = false 
    }
    private func setupMethodChannel(_ controller: FlutterViewController) {
        let screenSharingChannel = FlutterMethodChannel(
            name: AppDelegate.channelName,
            binaryMessenger: controller.binaryMessenger)
        
        screenSharingChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleScreenSharingMethodCall(call, result: result)
        }
    }
    private func handleScreenSharingMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        os_log("Received method call: %{public}s", log: logger, type: .debug, call.method)
        switch call.method {
        case "startScreenSharing":
            startScreenSharing(result: result)
        case "stopScreenSharing":
            stopScreenSharing(result: result)
        case "isScreenSharingAvailable":
            checkScreenSharingAvailability(result: result)
        case "isRecording":
            result(isRecording)
        default:
            os_log("Method not implemented: %{public}s", log: logger, type: .error, call.method)
            result(FlutterMethodNotImplemented)
        }
    }
    private func checkScreenSharingAvailability(result: @escaping FlutterResult) {
        guard let recorder = screenRecorder else {
            result(FlutterError(
                code: "RECORDER_ERROR",
                message: "Screen recorder not initialized",
                details: nil
            ))
            return
        }
        
        result(recorder.isAvailable)
    }
    private func startScreenSharing(result: @escaping FlutterResult) {
        guard let recorder = screenRecorder else {
            os_log("Screen recorder not initialized", log: logger, type: .error)
            result(FlutterError(
                code: "RECORDER_ERROR",
                message: "Screen recorder not initialized",
                details: nil
            ))
            return
        }
        guard recorder.isAvailable else {
            os_log("Screen recording not available", log: logger, type: .error)
            result(FlutterError(
                code: "SCREEN_SHARING_UNAVAILABLE",
                message: "Screen sharing is not available on this device",
                details: nil
            ))
            return
        }
        guard !isRecording else {
            os_log("Screen recording already in progress", log: logger, type: .error)
            result(FlutterError(
                code: "ALREADY_RECORDING",
                message: "Screen recording is already in progress",
                details: nil
            ))
            return
        }
        recorder.startRecording { [weak self] error in
            if let error = error {
                os_log("Failed to start recording: %{public}s", log: self?.logger ?? .default, type: .error, error.localizedDescription)
                result(FlutterError(
                    code: "SCREEN_SHARING_ERROR",
                    message: "Failed to start screen sharing",
                    details: error.localizedDescription
                ))
            } else {
                os_log("Screen recording started successfully", log: self?.logger ?? .default, type: .info)
                self?.isRecording = true
                result(nil)
            }
        }
    }
    private func stopScreenSharing(result: @escaping FlutterResult) {
        guard let recorder = screenRecorder else {
            os_log("Screen recorder not initialized", log: logger, type: .error)
            result(FlutterError(
                code: "RECORDER_ERROR",
                message: "Screen recorder not initialized",
                details: nil
            ))
            return
        }
        guard isRecording else {
            os_log("No active recording to stop", log: logger, type: .error)
            result(FlutterError(
                code: "NOT_RECORDING",
                message: "No active recording to stop",
                details: nil
            ))
            return
        }
        recorder.stopRecording { [weak self] (previewController, error) in
            if let error = error {
                os_log("Failed to stop recording: %{public}s", log: self?.logger ?? .default, type: .error, error.localizedDescription)
                result(FlutterError(
                    code: "SCREEN_SHARING_ERROR",
                    message: "Failed to stop screen sharing",
                    details: error.localizedDescription
                ))
            } else {
                os_log("Screen recording stopped successfully", log: self?.logger ?? .default, type: .info)
                self?.isRecording = false
                result(nil)
            }
        }
    }
    override func applicationWillTerminate(_ application: UIApplication) {
        os_log("Application will terminate", log: logger, type: .info)
        if isRecording {
            screenRecorder?.stopRecording { _, _ in }
        }
        super.applicationWillTerminate(application)
    }
}
