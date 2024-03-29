import UIKit

class DetailViewControllerZoominAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var tranImageView : UIImageView! { didSet {
        
    }}
    
    var image : UIImage!
    
    var startpoint : CGRect!
    
    init(startpoint: CGRect, image : UIImage) {
        super.init()
        self.tranImageView = UIImageView(image: image)
        self.startpoint = startpoint
        self.image = image
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to) as! DetailViewController
        let containerView = transitionContext.containerView
        toViewController.completeAnuimated = false
        toViewController.AlbumImageView.isHidden = true
        tranImageView.layer.borderColor = UIColor.darkGray.cgColor
        tranImageView.layer.borderWidth = 0

        tranImageView.layer.cornerRadius = 10.0
        tranImageView.clipsToBounds = true
        containerView.addSubview(toViewController.view)
        toViewController.view.layer.opacity = 0
        containerView.addSubview(tranImageView)
        tranImageView.frame = startpoint
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut ,  animations: { [self] in
            tranImageView.frame = CGRect(x: 16, y: 96, width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
            CATransaction.begin()
            CATransaction.setAnimationDuration(transitionDuration(using: transitionContext) * 2)
            toViewController.view.layer.opacity = 1
            tranImageView.layer.borderWidth = 2
            CATransaction.commit()
        }, completion: { [self] finished in
            if finished {
                toViewController.completeAnuimated = true
                toViewController.AlbumImageView.isHidden = false
                tranImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        })
    }
}

