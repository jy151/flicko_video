import Flutter
import UIKit

final class NativeScreenProtectionPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate, FlutterSceneLifeCycleDelegate {
  private static let channelName = "flicko_video/native_screen_protection"
  private static let instance = NativeScreenProtectionPlugin()

  private var isEnabled = false
  private var recordingOverlay: UIView?
  private var backgroundOverlays = NSMapTable<UIWindow, UIView>(keyOptions: .weakMemory, valueOptions: .strongMemory)
  private var screenshotShieldTextField: UITextField?
  private weak var shieldedLayer: CALayer?
  private weak var originalLayerSuperlayer: CALayer?
  private var originalLayerIndex: UInt32?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
    if #available(iOS 13.0, *) {
      registrar.addSceneDelegate(instance)
    }
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        result(false)
        return
      }

      switch call.method {
      case "setEnabled":
        let args = call.arguments as? [String: Any]
        self.setEnabled(args?["enabled"] as? Bool ?? false)
        result(true)
      case "isCaptured":
        result(UIScreen.main.isCaptured)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    guard isEnabled else { return }
    showBackgroundOverlays()
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    hideBackgroundOverlays()
    guard isEnabled else { return }
    updateRecordingOverlay()
  }

  @available(iOS 13.0, *)
  func sceneWillResignActive(_ scene: UIScene) {
    guard isEnabled else { return }
    showBackgroundOverlays()
  }

  @available(iOS 13.0, *)
  func sceneDidBecomeActive(_ scene: UIScene) {
    hideBackgroundOverlays()
    guard isEnabled else { return }
    updateRecordingOverlay()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

private extension NativeScreenProtectionPlugin {
  func setEnabled(_ enabled: Bool) {
    if isEnabled == enabled {
      updateRecordingOverlay()
      return
    }

    isEnabled = enabled
    if enabled {
      registerObservers()
      installScreenshotShield()
      updateRecordingOverlay()
    } else {
      removeScreenshotShield()
      hideRecordingOverlay()
      hideBackgroundOverlays()
      NotificationCenter.default.removeObserver(self)
    }
  }

  func registerObservers() {
    NotificationCenter.default.removeObserver(self)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(capturedDidChange),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenshotWasTaken),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
  }

  @objc func capturedDidChange() {
    updateRecordingOverlay()
  }

  @objc func screenshotWasTaken() {
    guard isEnabled else { return }
    updateRecordingOverlay()
  }

  func updateRecordingOverlay() {
    guard isEnabled, UIApplication.shared.applicationState == .active, UIScreen.main.isCaptured else {
      hideRecordingOverlay()
      return
    }

    guard let window = keyWindow() else { return }
    if recordingOverlay?.window !== window {
      recordingOverlay?.removeFromSuperview()
      recordingOverlay = makeOverlay(in: window)
    }
    recordingOverlay?.isHidden = false
    window.bringSubviewToFront(recordingOverlay!)
  }

  func hideRecordingOverlay() {
    recordingOverlay?.removeFromSuperview()
    recordingOverlay = nil
  }

  func showBackgroundOverlays() {
    for window in activeWindows() {
      if backgroundOverlays.object(forKey: window) == nil {
        backgroundOverlays.setObject(makeOverlay(in: window), forKey: window)
      }
    }
  }

  func hideBackgroundOverlays() {
    let enumerator = backgroundOverlays.objectEnumerator()
    while let overlay = enumerator?.nextObject() as? UIView {
      overlay.removeFromSuperview()
    }
    backgroundOverlays.removeAllObjects()
  }

  func makeOverlay(in window: UIWindow) -> UIView {
    let overlay = UIView(frame: window.bounds)
    overlay.backgroundColor = .black
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.isUserInteractionEnabled = true
    window.addSubview(overlay)
    window.bringSubviewToFront(overlay)
    return overlay
  }

  func installScreenshotShield() {
    guard screenshotShieldTextField == nil, let rootView = rootView() else { return }
    guard let originalSuperlayer = rootView.layer.superlayer else { return }

    let field = UITextField(frame: .zero)
    field.isSecureTextEntry = true
    field.isUserInteractionEnabled = false
    field.backgroundColor = .clear
    field.textColor = .clear
    field.tintColor = .clear
    field.translatesAutoresizingMaskIntoConstraints = false

    rootView.addSubview(field)
    NSLayoutConstraint.activate([
      field.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
      field.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
      field.topAnchor.constraint(equalTo: rootView.topAnchor),
      field.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
    ])

    guard let secureCanvas = field.subviews.first else {
      field.removeFromSuperview()
      return
    }

    secureCanvas.isUserInteractionEnabled = false
    secureCanvas.translatesAutoresizingMaskIntoConstraints = false
    rootView.addSubview(secureCanvas)
    NSLayoutConstraint.activate([
      secureCanvas.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
      secureCanvas.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
      secureCanvas.topAnchor.constraint(equalTo: rootView.topAnchor),
      secureCanvas.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
    ])

    originalLayerSuperlayer = originalSuperlayer
    originalLayerIndex = originalSuperlayer.sublayers?.firstIndex(of: rootView.layer).map(UInt32.init)
    shieldedLayer = rootView.layer

    originalSuperlayer.addSublayer(field.layer)
    field.layer.sublayers?.last?.addSublayer(rootView.layer)
    screenshotShieldTextField = field
  }

  func removeScreenshotShield() {
    if let shieldedLayer, let originalLayerSuperlayer {
      if let originalLayerIndex {
        originalLayerSuperlayer.insertSublayer(shieldedLayer, at: originalLayerIndex)
      } else {
        originalLayerSuperlayer.addSublayer(shieldedLayer)
      }
    }
    screenshotShieldTextField?.removeFromSuperview()
    screenshotShieldTextField = nil
    shieldedLayer = nil
    originalLayerSuperlayer = nil
    originalLayerIndex = nil
  }

  func rootView() -> UIView? {
    keyWindow()?.rootViewController?.view
  }

  func keyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    }
    return UIApplication.shared.keyWindow
  }

  func activeWindows() -> [UIWindow] {
    if #available(iOS 13.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .filter { !$0.isHidden && $0.alpha > 0 }
    }
    return UIApplication.shared.windows.filter { !$0.isHidden && $0.alpha > 0 }
  }
}
