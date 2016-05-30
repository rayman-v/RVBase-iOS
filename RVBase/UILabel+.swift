import UIKit

extension UILabel {
    var fontSize: CGFloat {
        set {
            self.font = UIFont.systemFontOfSize(newValue)
        }
        get {
            return self.fontSize
        }
    }
}
