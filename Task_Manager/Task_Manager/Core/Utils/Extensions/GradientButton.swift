import UIKit

@IBDesignable
class GradientButton: UIButton {
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Inspectable Properties
    @IBInspectable var startColor: UIColor = UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 1.0) {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 1.0) {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var isRounded: Bool = true {
        didSet {
            if isRounded {
                layer.cornerRadius = frame.height / 2
                gradientLayer.cornerRadius = frame.height / 2
            }
        }
    }
    
    /// The direction of the gradient (0: vertical, 1: horizontal, 2: diagonal from top-left, 3: diagonal from top-right)
    @IBInspectable var gradientDirectionValue: Int = 1 {
        didSet {
            updateGradient()
        }
    }
    
    var gradientDirection: GradientDirection {
        get {
            switch gradientDirectionValue {
            case 0: return .vertical
            case 1: return .horizontal
            case 2: return .diagonalTopLeft
            case 3: return .diagonalTopRight
            default: return .horizontal
            }
        }
        set {
            switch newValue {
            case .vertical: gradientDirectionValue = 0
            case .horizontal: gradientDirectionValue = 1
            case .diagonalTopLeft: gradientDirectionValue = 2
            case .diagonalTopRight: gradientDirectionValue = 3
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        if isRounded {
            layer.cornerRadius = frame.height / 2
            gradientLayer.cornerRadius = frame.height / 2
        }
    }
    
    // MARK: - Setup
    private func setupGradient() {
        layer.masksToBounds = true
        
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Default styling
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        updateGradient()
    }
    
    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.startPoint
        gradientLayer.endPoint = gradientDirection.endPoint
    }
    
    // MARK: - State Management
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.7
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.9 : 1.0
        }
    }
    
    // MARK: - Helper Methods
    /// Apply preset primary style
    func applyPrimaryStyle() {
        startColor = UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 1.0)
        endColor = UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 1.0)
        gradientDirection = .horizontal
        isRounded = true
    }
    
    /// Apply preset success style
    func applySuccessStyle() {
        startColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        endColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        gradientDirection = .horizontal
        isRounded = true
    }
    
    /// Apply preset warning style
    func applyWarningStyle() {
        startColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
        endColor = UIColor(red: 0.9, green: 0.5, blue: 0.0, alpha: 1.0)
        gradientDirection = .horizontal
        isRounded = true
    }
    
    /// Apply preset danger style
    func applyDangerStyle() {
        startColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        endColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
        gradientDirection = .horizontal
        isRounded = true
    }
}

// MARK: - Gradient Direction
extension GradientButton {
    enum GradientDirection {
        case vertical
        case horizontal
        case diagonalTopLeft
        case diagonalTopRight
        
        var startPoint: CGPoint {
            switch self {
            case .vertical:
                return CGPoint(x: 0.5, y: 0.0)
            case .horizontal:
                return CGPoint(x: 0.0, y: 0.5)
            case .diagonalTopLeft:
                return CGPoint(x: 0.0, y: 0.0)
            case .diagonalTopRight:
                return CGPoint(x: 1.0, y: 0.0)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .vertical:
                return CGPoint(x: 0.5, y: 1.0)
            case .horizontal:
                return CGPoint(x: 1.0, y: 0.5)
            case .diagonalTopLeft:
                return CGPoint(x: 1.0, y: 1.0)
            case .diagonalTopRight:
                return CGPoint(x: 0.0, y: 1.0)
            }
        }
    }
}
