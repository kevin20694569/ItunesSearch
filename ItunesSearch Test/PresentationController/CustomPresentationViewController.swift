import UIKit

class CustomPresentationViewController : UIPresentationController {
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.layer.cornerRadius = 30.0
        presentedView?.clipsToBounds = true
    }
}

