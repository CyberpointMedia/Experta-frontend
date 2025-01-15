import ReplayKit
import AVFoundation
import Flutter

class ScreenRecordingService: NSObject, RPScreenRecorderDelegate {
    static let shared = ScreenRecordingService()
    private var screenRecorder = RPScreenRecorder.shared()
    private var videoOutputURL: URL?
    private var videoWriter: AVAssetWriter?
    private var videoWriterInput: AVAssetWriterInput?
    private var audioWriterInput: AVAssetWriterInput?
    private var audioAppWriterInput: AVAssetWriterInput?
    private var isRecording = false

    override init() {
        super.init()
        screenRecorder.delegate = self
    }

    private func saveRecordingMetadata(filePath: String) {
        if let flutterEngine = (UIApplication.shared.delegate as? FlutterAppDelegate)?.flutterEngine {
            let channel = FlutterMethodChannel(
                name: "com.example.expert/recording_metadata",
                binaryMessenger: flutterEngine.binaryMessenger)
            
            let metadata: [String: Any] = [
                "path": filePath,
                "timestamp": ISO8601DateFormatter().string(from: Date())
            ]
            
            channel.invokeMethod("saveMetadata", arguments: metadata)
        }
    }

    func startRecording(completion: @escaping (Error?) -> Void) {
        guard !isRecording else {
            completion(nil)
            return
        }

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let filename = "screen_recording_\(timestamp).mp4"
        
        do {
            let recordingsDir = documentsURL.appendingPathComponent("Recordings")
            try fileManager.createDirectory(at: recordingsDir, withIntermediateDirectories: true, attributes: nil)
            videoOutputURL = recordingsDir.appendingPathComponent(filename)
            
            if fileManager.fileExists(atPath: videoOutputURL!.path) {
                try fileManager.removeItem(at: videoOutputURL!)
            }

            videoWriter = try AVAssetWriter(outputURL: videoOutputURL!, fileType: .mp4)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: UIScreen.main.bounds.width * UIScreen.main.scale,
                AVVideoHeightKey: UIScreen.main.bounds.height * UIScreen.main.scale,
                AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill
            ]
            videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            videoWriterInput?.expectsMediaDataInRealTime = true
            
            let audioSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioWriterInput?.expectsMediaDataInRealTime = true
            
            audioAppWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioAppWriterInput?.expectsMediaDataInRealTime = true

            guard let videoWriter = videoWriter,
                  let videoWriterInput = videoWriterInput,
                  let audioWriterInput = audioWriterInput,
                  let audioAppWriterInput = audioAppWriterInput else {
                throw NSError(domain: "ScreenRecordingService", code: -1, 
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create writer inputs"])
            }

            if videoWriter.canAdd(videoWriterInput) {
                videoWriter.add(videoWriterInput)
            }
            if videoWriter.canAdd(audioWriterInput) {
                videoWriter.add(audioWriterInput)
            }
            if videoWriter.canAdd(audioAppWriterInput) {
                videoWriter.add(audioAppWriterInput)
            }

            isRecording = true
            screenRecorder.isMicrophoneEnabled = true
            
            screenRecorder.startCapture { sampleBuffer, sampleType, error in
                if let error = error {
                    self.isRecording = false
                    completion(error)
                    return
                }

                switch sampleType {
                case .video:
                    if videoWriter.status == .unknown {
                        videoWriter.startWriting()
                        videoWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                    }
                    if videoWriter.status == .writing && videoWriterInput.isReadyForMoreMediaData {
                        videoWriterInput.append(sampleBuffer)
                    }
                case .audioMic:
                    if videoWriter.status == .writing && audioWriterInput.isReadyForMoreMediaData {
                        audioWriterInput.append(sampleBuffer)
                    }
                case .audioApp:
                    if videoWriter.status == .writing && audioAppWriterInput.isReadyForMoreMediaData {
                        audioAppWriterInput.append(sampleBuffer)
                    }
                @unknown default:
                    break
                }
            } completionHandler: { error in
                if let error = error {
                    self.isRecording = false
                }
                completion(error)
            }
        } catch {
            isRecording = false
            completion(error)
        }
    }

    func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        guard isRecording else {
            completion(nil, nil)
            return
        }

        screenRecorder.stopCapture { error in
            if let error = error {
                self.isRecording = false
                completion(nil, error)
                return
            }

            self.videoWriterInput?.markAsFinished()
            self.audioWriterInput?.markAsFinished()
            self.audioAppWriterInput?.markAsFinished()
            
            self.videoWriter?.finishWriting { [weak self] in
                guard let self = self else { return }
                self.isRecording = false
                if let videoURL = self.videoOutputURL {
                    self.saveRecordingMetadata(filePath: videoURL.path)
                }
                completion(self.videoOutputURL, nil)
                
                self.videoWriter = nil
                self.videoWriterInput = nil
                self.audioWriterInput = nil
                self.audioAppWriterInput = nil
            }
        }
    }
}
