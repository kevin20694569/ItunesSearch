import UIKit

class SlidingHeaderViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.layer.borderColor = UIColor.red.cgColor
        v.layer.borderWidth = 8
        v.contentInsetAdjustmentBehavior = .never
        return v
    }()
    let slidingHeaderView: SlidingHeaderView = {
        let v = SlidingHeaderView()
        return v
    }()
    let contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemYellow
        return v
    }()
    
    // Top constraint for the slidingHeaderView
    var slidingViewTopC: NSLayoutConstraint!
    
    // to track the scroll activity
    var curScrollY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        [scrollView, slidingHeaderView, contentView].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // add contentView and slidingHeaderView to the scroll view
        [contentView, slidingHeaderView].forEach { v in
            scrollView.addSubview(v)
        }
        
        // add scroll view to self.view
        view.addSubview(scrollView)
        
        let safeG = view.safeAreaLayoutGuide
        let contentG = scrollView.contentLayoutGuide
        let frameG = scrollView.frameLayoutGuide

        
        // we're going to change slidingHeaderView's Top constraint relative to the Top of the scroll view FRAME
        slidingViewTopC = slidingHeaderView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
        
        NSLayoutConstraint.activate([
            
            // scroll view Top to view Top
            scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
            
            // scroll view Leading/Trailing/Bottom to safe area
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: 0.0),
            
            // constrain slidingHeaderView Top to scroll view's FRAME
            slidingViewTopC,
            
            // slidingHeaderView to Leading/Trailing of scroll view FRAME
            slidingHeaderView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 0.0),
            slidingHeaderView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: 0.0),
            
            // no Height or Bottom constraint for slidingHeaderView
            
            // content view Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
            contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
            contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
            contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
            
            // content view Width to scroll view's FRAME
            contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 0.0),
            
        ])
        
        // add some content to the content view so we have something to scroll
        addSomeContent()
        
        // because we're going to track the scroll offset
        scrollView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
      //  print("ruifkhwero\(slidingHeaderView.frame.height)")
        if slidingHeaderView.frame.height == 0 {
            // get the size of the slidingHeaderView
            let sz = slidingHeaderView.systemLayoutSizeFitting(CGSize(width: scrollView.frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
            // use its Height for the scroll view's Top contentInset
            scrollView.contentInset = UIEdgeInsets(top: sz.height, left: 0, bottom: 0, right: 0)
        }
    }
    
    func addSomeContent() {
        // create a vertical stack view with a bunch of labels
        //  and add it to our content view so we have something to scroll
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.backgroundColor = .gray
        stack.translatesAutoresizingMaskIntoConstraints = false
        for i in 1...20 {
            let v = UILabel()
            v.text = "Label \(i)"
            v.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            v.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
            stack.addArrangedSubview(v)
        }
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
        ])
    }
    
}

extension SlidingHeaderViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        curScrollY = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diffY = scrollView.contentOffset.y - curScrollY
      //  print(scrollView.contentOffset.y)
        
        var newY: CGFloat = slidingViewTopC.constant - diffY
    //    print(newY)
        if diffY < 0 {
            // we're scrolling DOWN
            newY = min(newY, 0.0)
        } else {
            // we're scrolling UP
            if scrollView.contentOffset.y <= -slidingHeaderView.frame.height {
                newY = 0.0
            } else {
                newY = max(-slidingHeaderView.frame.height, newY)
            }
        }
        print(newY)
        
        // update slidingHeaderView Top constraint constant
        slidingViewTopC.constant = newY
        curScrollY = scrollView.contentOffset.y
    }
    
}




class SlidingHeaderView: UIView {
    
    // simple view with two labels
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        
        backgroundColor = .systemBlue
        
        let v1 = UILabel()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.text = "Label 1"
        v1.backgroundColor = .yellow
        addSubview(v1)
        
        let v2 = UILabel()
        v2.translatesAutoresizingMaskIntoConstraints = false
        v2.text = "Label 2"
        v2.backgroundColor = .yellow
        addSubview(v2)
        
        NSLayoutConstraint.activate([
            
            v1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            v1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            v2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            v2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            
            v1.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            v2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            
            v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 4.0),
            
            v2.heightAnchor.constraint(equalTo: v1.heightAnchor),
            
        ])
        
    }
    
}
