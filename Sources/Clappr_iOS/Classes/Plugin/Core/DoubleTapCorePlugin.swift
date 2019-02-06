import UIKit

public class DoubleTapCorePlugin: DoubleTapPlugin {
    
    override open var pluginName: String {
        return String(describing: DoubleTapCorePlugin.self)
    }

    override public func render() {
        addGestures()
    }
    
    private func addGestures() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2

        if let coreGesture = core?.view.gestureRecognizers?.first as? UITapGestureRecognizer {
            coreGesture.require(toFail: doubleTapGesture)
            core?.view.addGestureRecognizer(doubleTapGesture)
        }
    }

    @objc private func doubleTap(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            let xPosition = gestureRecognizer.location(in: view).x
            doubleTapSeek(xPosition: xPosition)
        }
    }
}
