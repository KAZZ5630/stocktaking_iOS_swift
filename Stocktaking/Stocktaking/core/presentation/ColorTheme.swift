import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/256, green: CGFloat(green)/256, blue: CGFloat(blue)/256, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int, alpha: Float) {
        self.init(red: CGFloat(red)/256, green: CGFloat(green)/256, blue: CGFloat(blue)/256, alpha: CGFloat(alpha))
    }
}

public struct ColorTheme {
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let lightBgColor: UIColor
    let highlightedColor: UIColor
    let textFieldBgColor: UIColor
    let transparent: UIColor
    
    static func mainTheme() -> ColorTheme {
        return ColorTheme(
            backgroundColor: UIColor(red: 19, green: 40, blue: 51),
            foregroundColor: UIColor(red: 229, green: 232, blue: 237),
            lightBgColor: UIColor(red: 97, green: 99, blue: 102),
            highlightedColor: UIColor(red: 102, green: 102, blue: 49),
            textFieldBgColor: UIColor(red: 160, green: 163, blue: 168, alpha: 0.6),
            transparent: UIColor(white: 1, alpha: 0)
        )
    }
}
