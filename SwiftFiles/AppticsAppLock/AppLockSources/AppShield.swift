

import UIKit

@objcMembers public class AppticsLock: NSObject {
    
    private var shouldShowPasscode: Bool = true
    private var isBlurredOverlayShown: Bool = true
    
   
    public var customAppIcon:UIImage?
    var defaulTheme : AppShieldTheme?
    var customLocalized:Localized?
    internal var isCustomLocalized = false
    public static let shared = AppticsLock()
    
    internal var reasonString:String?
    
    /// Tag used to find/remove blur overlay views without retaining their windows.
    private let blurViewTag = 1789

    /// Snapshot of the last screen, kept in memory (never in UserDefaults) and cleared on unlock.
    internal var lastSnapshotImage: UIImage?

    /// Guards against registering the lifecycle observers more than once when `initialize`
    /// is called repeatedly (e.g. once per scene in a multi-window app).
    private var didRegisterObservers = false

    internal var locktintColor = { () -> UIColor in
        if #available(iOS 12.0, *) {
            if (UIScreen.main.traitCollection.userInterfaceStyle == .dark){
                return UIColor.white
            }
            else{
                return UIColor.black
            }
        } else {
            // Fallback on earlier versions
            return UIColor.black
        }
    }()

    internal var delayTimeFromDefaults =  UserDefaults.standard.object(forKey: "delayTime") ?? 0
    
    public var window : UIWindow = {

        return UIWindow()
    }()
    var mainWindow: UIWindow?
    
    var isValidating  = false
    
    public var isUnlocked: Bool = false
    
    private(set) var registeredWindows: [UIWindow] = []
    
    var authWindows: [UIWindow] = []
    
    
    
    
    public var config = AuthenticationConfiguration(blurBackgroundColor: nil, delayTime: nil, shouldAllowIfPasscodeTurnedoff: false)
    
    public func initialize(mainWindow: UIWindow,configuration : AuthenticationConfiguration?=nil,with theme:AppShieldTheme? = nil,customizeLocalization:Localized? = nil) {
        
        self.defaulTheme = theme ?? DefaultTheme()
        self.mainWindow = mainWindow

        // Register lifecycle observers only once, even if initialize is called per scene.
        if !didRegisterObservers {
            self.addObservers()
            didRegisterObservers = true
        }

        // One-time cleanup: older versions archived a full-screen screenshot under "view" in
        // UserDefaults (memory-resident). Snapshots are now kept in memory instead.
        UserDefaults.standard.removeObject(forKey: "view")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            AppticsLock.shared.storeKeyIndefaults()
        })

        if let conf = configuration{
            self.config = conf
            self.config.lockTintColor = conf.lockTintColor
            guard let storedTime  = delayTimeFromDefaults as? Double else{
                return
            }
            self.config.delayTime = storedTime
        }
        self.customLocalized = customizeLocalization
       

    }
    @objc public func setReasonStringToAccess(_ reason:String){
        reasonString = reason
    }
    
    public func authenticate(then: ((_ success: Bool, _ errorString: String?)->())?) {
        
       
        
        if !isAuthenticatorEnabled {
            then?(true,nil)
            return
        }
        
        Authenticator().authenticateWithPasscode { (result) in
            switch result {
            case .success(_):
                then?(true, nil)
            case .failure(let error):
                then?(false, Authenticator.parseError(error))
            }
        }
        
        
    }
    public func updateDelayTime(_ time:Double){
        //print("delayed ")
        self.config.setDelay(time)
        self.storeDelayToDefaults(time: time)
    }
    
    public func register(window: UIWindow) {
            if !registeredWindows.contains(where: { $0 === window }) {
                registeredWindows.append(window)
            }
    }
    
   


//    @available(iOS 13.0, *)
//    func getCurrentScene()->UIWindowScene?{
//        let scenes = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene})
//        let windowscenes = scenes.compactMap({$0})
//        var keyWindowScene : UIWindowScene!
//        for wscene in windowscenes {
//            let kscenes = wscene.windows.filter({$0.isKeyWindow})
//            if(kscenes.count > 0){
//                keyWindowScene = wscene
//            }
//        }
//        return keyWindowScene
//    }
    ///presents authentication screen with no blur background
    public func validateAuthentication(then: @escaping (Result<Any, Error>) -> Void){
        self.isValidating = true
        Authenticator().authenticateWithPasscode { [weak self] (result) in
            // Always clear the flag when done, so normal lock-blur behaviour resumes
            // and the flag never stays stuck `true` after a validate.
            self?.isValidating = false
            then(result)
        }
    }
    ///toggles between passcode on and off.
    /// - Parameters:
    ///     - forceToggle: The force toggle button toggles with.out checking if the user has authentication enabled in the device. This screen will block users until he enables authentication in device
    
   @discardableResult public func toggleAuthenticator(_ on: Bool,forceToggle:Bool? = false,completionBlock:@escaping ((Bool)->())) -> Bool {
        
      
        if on {
            if forceToggle ?? false{
                AppLockManager.shared.enableAppLock()
                return AuthenticatorKeychain().save(asString: "true")
            }
            else{
              
                if Authenticator().canAuthenticate() {
                    AppLockManager.shared.enableAppLock()
                    return AuthenticatorKeychain().save(asString: "true")
                }else {
                    completionBlock(true)
                    return false
                }
            }
           
        }else {
            AppticsLock.shared.validateAuthentication { (result) in
                switch result {
                case .success(_):
                    completionBlock(true)
                    AuthenticatorKeychain().save(asString: "false")
                    AppLockManager.shared.removeAllItems()
                case .failure( _):
                    completionBlock(false)
                    AppLockManager.shared.enableAppLock()
                    AuthenticatorKeychain().save(asString: "true")
                }
            }


            return AuthenticatorKeychain().save(asString: "false")
        }
       return true
    }
    
    public var isAuthenticatorEnabled: Bool {
        return AuthenticatorKeychain().get() == "true"
    }
    
   
    public func updateConfig(_ config:AuthenticationConfiguration){
        self.config = config
    }

    private func storeDelayToDefaults(time:Double){
         UserDefaults.standard.set(time , forKey: "delayTime")
    }
}


extension AppticsLock {
    
    internal func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLaunch), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object:nil)
         NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timeDidChange), name:Notification.Name.NSSystemClockDidChange, object:nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUnlocked),
            name: .appDidUnlock,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneWillDeactivate(_:)),
            name: UIScene.willDeactivateNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneDidEnterBackground(_:)),
            name: UIScene.didEnterBackgroundNotification,
            object: nil
        )


        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneDidConnect(_:)),
            name: UIScene.willConnectNotification,
            object: nil
        )

        // Prune windows belonging to a scene when it disconnects, so registeredWindows /
        // authWindows don't retain dead windows across scene connect/disconnect cycles.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneDidDisconnect(_:)),
            name: UIScene.didDisconnectNotification,
            object: nil
        )
    }

    @objc private func sceneDidDisconnect(_ notification: Notification) {
        guard let scene = notification.object as? UIWindowScene else { return }
        // Drop references to windows from the disconnected scene (and any orphaned windows).
        registeredWindows.removeAll { $0.windowScene == nil || $0.windowScene === scene }
        for window in authWindows where window.windowScene == nil || window.windowScene === scene {
            window.rootViewController = nil
            window.isHidden = true
        }
        authWindows.removeAll { $0.windowScene == nil || $0.windowScene === scene }
    }

    @objc private func sceneDidConnect(_ notification: Notification) {
        guard isAuthenticatorEnabled else { return }
        guard !isUnlocked else { return }   // ✅ skip if already unlocked

        // get the scene
        guard let scene = notification.object as? UIWindowScene else { return }

        // Don't add a second auth overlay if this scene already has one (Fix #3).
        guard !authWindows.contains(where: { $0.windowScene === scene }) else { return }

        for window in scene.windows {
            if !authWindows.contains(where: { $0 === window }) {
                let overlayWindow = UIWindow(windowScene: scene)
                let authVC = AuthenticatorViewController()
                authVC.isPrimaryPrompt = authWindows.isEmpty // only first window prompts
                overlayWindow.rootViewController = authVC
                overlayWindow.windowLevel = .alert + 1
                overlayWindow.makeKeyAndVisible()
                authWindows.append(overlayWindow)
            }
        }
    }

    
    @objc private func sceneWillDeactivate(_ notification: Notification) {
        guard let scene = notification.object as? UIWindowScene else { return }
        blurAllWindows(in: scene)
    }

    @objc private func sceneDidEnterBackground(_ notification: Notification) {
        guard let scene = notification.object as? UIWindowScene else { return }
        blurAllWindows(in: scene)
    }
    
    private func blurAllWindows(in scene: UIWindowScene) {
        // Skip while validating — validateAuthentication() must not cover the screen.
        guard isAuthenticatorEnabled, !isValidating else { return }
        for window in scene.windows {
            // Skip auth overlay windows
            if authWindows.contains(where: { $0 === window }) { continue }
            addBlur(to: window)
        }
    }

    /// Adds a single blur overlay to a window, identified by `blurViewTag`. No window is retained;
    /// the overlay lives on the view hierarchy and is looked up / removed by its tag.
    private func addBlur(to window: UIWindow) {
        if window.viewWithTag(blurViewTag) != nil { return }   // already blurred
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.frame = window.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = blurViewTag
        window.addSubview(blurView)
        window.bringSubviewToFront(blurView)
    }

    
    @objc private func handleUnlocked() {
        removeEntryAuthenticator()
        lastSnapshotImage = nil   // free the in-memory snapshot once unlocked
    }
    @objc private func timeDidChange() {
        self.showEntryAuthenticator()

    }
    
    @objc private func didFinishLaunch() {
       
        if isFirstLaunch{
            self.removePassCode()
            return
        }
        if !isFirstLaunch || hasExceededDelay(){
            
            self.showEntryAuthenticator()
        }
    }
    
    @objc private func WillResignActive() {
        
        // Keep the snapshot in memory only — never archive a full-screen image into UserDefaults.
        self.lastSnapshotImage = AuthenticatorBlurViewController.takeScreenshot()
        if AppticsLock.shared.isAuthenticatorEnabled{
            if !AppticsLock.shared.isValidating{
                if shouldShowPasscode && (config.delayTime < 1 ){
                    self.showNewBlur()
                    shouldShowPasscode = true
                }
                
            }
        }
            
    }
    
    
    @objc private func didEnterBackground() {
        
        shouldShowPasscode = true
        isUnlocked = false
        self.setAppEnteredBackgroundAt()
    }
    
    @objc private func willEnterForeground() {
        if hasExceededDelay(){
            if isFirstLaunch{
            self.removePassCode()
            return
            }
            self.showEntryAuthenticator()
        }

    }
    @objc private func willTerminate (){
        
       
    }
    @objc private func didBecomeActive() {
        // When the app returns to active and no lock screen is up, clear any stray blur
        // (from showNewBlur or the scene-deactivate path). If a lock IS showing
        // (authWindows not empty), keep the blur behind it until the user unlocks.
        if authWindows.isEmpty {
            self.hideNewBlur()
        }
    }
    
}


extension AppticsLock {
    
    func showEntryAuthenticator() {
        guard isAuthenticatorEnabled else { return }
        guard !isUnlocked else { return }   // ✅ skip if already unlocked

        shouldShowPasscode = false
        removeEntryAuthenticator()

        var didSetPrompt = false

        for baseWindow in registeredWindows {
            if authWindows.contains(where: { $0.windowScene == baseWindow.windowScene }) {
                continue
            }
            guard let scene = baseWindow.windowScene else { continue }

            let overlayWindow = UIWindow(windowScene: scene)

            let authVC = AuthenticatorViewController()
            authVC.isPrimaryPrompt = !didSetPrompt   // first one gets prompt
            overlayWindow.rootViewController = authVC

            overlayWindow.windowLevel = .alert + 1
            overlayWindow.tag = 33
            overlayWindow.makeKeyAndVisible()

            authWindows.append(overlayWindow)

            didSetPrompt = true
        }
    }

    
    func removeEntryAuthenticator() {
            guard isAuthenticatorEnabled else { return }
            shouldShowPasscode = true

            for window in authWindows {
                window.rootViewController = nil
                window.isHidden = true
                window.windowLevel = .normal
                window.tag = 0
            }

            authWindows.removeAll()
            lastSnapshotImage = nil   // free the in-memory snapshot once unlocked
        }


    func showNewBlur() {
        guard isAuthenticatorEnabled else { return }

        isBlurredOverlayShown = false

        // Delay slightly to let all scenes report their windows
        DispatchQueue.main.async {
            // Race guard: if the app became active again before this deferred block runs,
            // didBecomeActive already ran hideNewBlur — don't strand a blur view.
            guard !self.isBlurredOverlayShown else { return }

            for scene in UIApplication.shared.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else { continue }

                for window in windowScene.windows {
                    // Skip overlay auth windows
                    if self.authWindows.contains(where: { $0 === window }) { continue }

                    // Must be visible and normal
                    guard !window.isHidden else { continue }

                    self.addBlur(to: window)
                }
            }
        }
    }
    func hideNewBlur() {
        // Mark first so any in-flight showNewBlur async block bails out (race guard).
        isBlurredOverlayShown = true
        for scene in UIApplication.shared.connectedScenes {
            (scene as? UIWindowScene)?.windows.forEach {
                $0.viewWithTag(blurViewTag)?.removeFromSuperview()
            }
        }
    }

    
    func removeBlurAuthenticator() {
        if !isAuthenticatorEnabled { return }
        isBlurredOverlayShown = true
        self.window.rootViewController = nil
        self.window.windowLevel = UIWindow.Level(rawValue: 0)
        self.window.isHidden = true
        self.window.tag = 34
        self.mainWindow?.makeKeyAndVisible()
    }
    
    
    public func storeKeyIndefaults(){
       // print("set=======")
        if let keyName = config.userdefaultKeyName{
            UserDefaults.standard.set("yes", forKey: keyName + "." + "isFirstLaunch")
        }
        else{
            UserDefaults.standard.set("yes", forKey: "isFirstLaunch")
        }
       
        
    }
    public func removePassCode(){
        AuthenticatorKeychain().save(asString: "false")
        if let keyName = config.userdefaultKeyName{
            UserDefaults.standard.removeObject(forKey: keyName + "." + "isFirstLaunch")
        }
        else{
            UserDefaults.standard.removeObject(forKey: "isFirstLaunch")
        }
         UserDefaults.standard.removeObject(forKey: "delayTime")
        
        AppLockManager.shared.removeAllItems()

    }



    public var isFirstLaunch: Bool {
        if let keyName = config.userdefaultKeyName{
            if (UserDefaults.standard.object(forKey:  keyName + "." + "isFirstLaunch") == nil){
                AuthenticatorKeychain().save(asString: "false")
                
                return true
            }
        }
        else{
            if (UserDefaults.standard.object(forKey: "isFirstLaunch") == nil){
                AuthenticatorKeychain().save(asString: "false")
                return true
            }
        }
        
        return false
    }
    func setAppEnteredBackgroundAt()
    {
        let currentTime = Date().timeIntervalSinceReferenceDate
        
        UserDefaults.standard.set(currentTime, forKey: "time")
        UserDefaults.standard.synchronize()
    }
    
    func getAppEnteredBackgroundAt() -> Double
    {
        let time = UserDefaults.standard.double(forKey:"time")
        
        return time
    }
    func hasExceededDelay() -> Bool
    {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let appEnteredBackgroundAt = getAppEnteredBackgroundAt()
        
        let resignDuration = currentTime - appEnteredBackgroundAt
        let delayAmount = config.delayTime ?? 0
        
        if(resignDuration > Double(delayAmount))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}


final class SecureSnapshotView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension Notification.Name {
    static let appDidUnlock = Notification.Name("appDidUnlock")
}




