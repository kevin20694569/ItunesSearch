import UIKit

class WebViewControllerZoominAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromViewController = transitionContext.viewController(forKey: .from) as! DetailViewController
        let toViewController = transitionContext.viewController(forKey: .to)
        let bounds = toViewController!.view.bounds
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController!.view)
        toViewController?.view.frame = CGRect(x: 0, y: bounds.height , width: bounds.width, height: bounds.height)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut ,  animations: {
            fromViewController.view.center.y -= bounds.height
            
            toViewController!.view.center.y -= bounds.height
        }, completion: { finished in
            if finished {
                transitionContext.completeTransition(true)
            }
        })
    }
}
class WebViewControllerZoomOutAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let bounds = UIScreen.main.bounds
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        let containerView = transitionContext.containerView
        containerView.addSubview(fromViewController!.view)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut , animations: { 
            toViewController?.view.center.y += bounds.height
            fromViewController?.view.center.y += bounds.height
        }, completion: { finished in
            if finished {
                
               transitionContext.completeTransition(true)
            }
        })
    }
}
