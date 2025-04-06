import UIKit
import SVProgressHUD

public struct PPHUD {
    // MARK: - Setup
    private static var isConfigured = false
    
    private static func setupIfNeeded() {
        guard !isConfigured else { return }
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        isConfigured = true
    }
    
    // MARK: - Public Methods
    public static func show() {
        inMain {
            setupIfNeeded()
            SVProgressHUD.show()
        }
    }
    
    public static func dismiss() {
        inMain {
            SVProgressHUD.dismiss()
        }
    }
    
    public static func showSuccess(_ message: String? = nil) {
        inMain {
            setupIfNeeded()
            SVProgressHUD.showSuccess(withStatus: message)
        }
    }
    
    public static func showError(_ message: String? = nil) {
        inMain {
            setupIfNeeded()
            SVProgressHUD.showError(withStatus: message)
        }
    }
    
    public static func showInfo(_ message: String) {
        inMain {
            setupIfNeeded()
            SVProgressHUD.showInfo(withStatus: message)
        }
    }
}

// Keep your existing inMain helper
private func inMain(closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}
