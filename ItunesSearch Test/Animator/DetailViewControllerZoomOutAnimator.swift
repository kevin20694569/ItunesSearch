import UIKit

class DetailViewControllerZoomOutAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var tranImageView : UIImageView!
    
    var startpoint : CGRect!
    
    init(image : UIImage, startpoint: CGRect) {
        super.init()
        self.tranImageView = UIImageView(image: image)
        self.startpoint = startpoint
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from) as! DetailViewController
        let containerView = transitionContext.containerView
        fromViewController.view.layer.opacity = 1
       fromViewController.AlbumImageView.isHidden = true
        containerView.addSubview(tranImageView)
        tranImageView.layer.cornerRadius = 10.0
        tranImageView.clipsToBounds = true
        tranImageView.frame = CGRect(x: 16, y: 96, width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut , animations: { [self] in
            CATransaction.begin()
            CATransaction.setAnimationDuration(transitionDuration(using: transitionContext) * 2)
            fromViewController.view.layer.opacity = 0
            CATransaction.commit()
            tranImageView.frame = startpoint
        }, completion: { [self] finished in
            if finished {
                fromViewController.AlbumImageView.isHidden = false
                tranImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        })
    }
}
