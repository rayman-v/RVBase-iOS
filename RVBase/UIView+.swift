import UIKit

extension UIView {
    
    func createVerticalScroll(contentHeight height: CGFloat) -> UIView {
        let scrollWindow = UIScrollView()
        scrollWindow.alwaysBounceVertical = true
        addSubview(scrollWindow)
        scrollWindow.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        let scrollContainer = UIView()
        scrollWindow.addSubview(scrollContainer)
        scrollContainer.snp_makeConstraints { (make) in
            make.edges.equalTo(scrollWindow)
            make.width.equalTo(scrollWindow)
            make.height.equalTo(height)
        }
        
        return scrollContainer
    }
    
    func shadow(color color: UIColor = UIColor.grayColor(), offset: CGSize = CGSizeZero, radius: CGFloat = 0.5, opacity: Float = 0.5) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.CGColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    func topBorder(color color: UIColor = UIColor.grayColor(), weight: CGFloat = 0.5, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
        let line = UIView()
        line.backgroundColor = color
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(self).inset(edgeInsets.left)
            make.right.equalTo(self).inset(edgeInsets.right)
            make.top.equalTo(self).inset(edgeInsets.top)
            make.height.equalTo(weight)
        }
    }
    
    func rightBorder(color color: UIColor = UIColor.grayColor(), weight: CGFloat = 0.5, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
        let line = UIView()
        line.backgroundColor = color
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).inset(edgeInsets.bottom)
            make.right.equalTo(self).inset(edgeInsets.right)
            make.top.equalTo(self).inset(edgeInsets.top)
            make.width.equalTo(weight)
        }
    }
    
    func bottomBorder(color color: UIColor = UIColor.grayColor(), weight: CGFloat = 0.5, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
        let line = UIView()
        line.backgroundColor = color
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).inset(edgeInsets.bottom)
            make.right.equalTo(self).inset(edgeInsets.right)
            make.left.equalTo(self).inset(edgeInsets.left)
            make.height.equalTo(weight)
        }
    }
    
    func leftBorder(color color: UIColor = UIColor.grayColor(), weight: CGFloat = 0.5, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
        let line = UIView()
        line.backgroundColor = color
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).inset(edgeInsets.bottom)
            make.top.equalTo(self).inset(edgeInsets.top)
            make.left.equalTo(self).inset(edgeInsets.left)
            make.width.equalTo(weight)
        }
    }
    
    func addToSuperview(superview: UIView) {
        superview.addSubview(self)
    }
}
