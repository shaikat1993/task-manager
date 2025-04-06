import UIKit

// MARK: - Gradient Configuration
extension UIButton {
    private struct AssociatedKeys {
        static var gradientLayer = "gradientLayer"
    }
    
    /// The gradient layer associated with the button
    private var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.gradientLayer) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.gradientLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Applies a gradient to the button with specified colors and direction
    /// - Parameters:
    ///   - colors: Array of colors to use in the gradient
    ///   - direction: Direction of the gradient (default: .horizontal)
    ///   - cornerRadius: Corner radius of the button (default: height/2)
    func applyGradient(
        colors: [UIColor],
        direction: GradientButton.GradientDirection = .horizontal,
        cornerRadius: CGFloat? = nil
    ) {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        // Create new gradient layer
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        
        // Apply corner radius
        let radius = cornerRadius ?? frame.height / 2
        layer.cornerRadius = radius
        gradient.cornerRadius = radius
        
        // Set frame and add gradient
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Default styling
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.masksToBounds = true
    }
    
    /// Updates the gradient frame when the button's bounds change
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

// MARK: - Preset Gradients
extension UIButton {
    /// Applies a primary gradient style (Purple to Blue)
    func applyPrimaryGradient() {
        applyGradient(
            colors: [
                UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 1.0),
                UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 1.0)
            ]
        )
    }
    
    /// Applies a success gradient style (Green shades)
    func applySuccessGradient() {
        applyGradient(
            colors: [
                UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0),
                UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
            ]
        )
    }
    
    /// Applies a warning gradient style (Orange shades)
    func applyWarningGradient() {
        applyGradient(
            colors: [
                UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0),
                UIColor(red: 0.9, green: 0.5, blue: 0.0, alpha: 1.0)
            ]
        )
    }
    
    /// Applies a danger gradient style (Red shades)
    func applyDangerGradient() {
        applyGradient(
            colors: [
                UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0),
                UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
            ]
        )
    }
}
