import UIKit

enum DesignSystem {
    // Colors
    enum Colors {
        static let primary = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1.0) // Example blue
        static let secondary = UIColor(red: 0.93, green: 0.26, blue: 0.21, alpha: 1.0) // Example red
        static let background = UIColor.white
        static let textPrimary = UIColor.black
        static let textSecondary = UIColor.darkGray
    }
    
    // Fonts
    enum Fonts {
        static func heading1() -> UIFont {
            return UIFont.systemFont(ofSize: 24, weight: .bold)
        }
        
        static func heading2() -> UIFont {
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        
        static func body() -> UIFont {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        
        static func caption() -> UIFont {
            return UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
    
    // Spacing
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}
