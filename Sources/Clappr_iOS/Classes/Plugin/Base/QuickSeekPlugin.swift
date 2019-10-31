import UIKit

public class QuickSeekPlugin: UICorePlugin {
    private let seekDuration = 10.0
    var doubleTapGesture: UITapGestureRecognizer!

    open class override var name: String {
        return "QuickSeekPlugin"
    }
    
    private var animatonHandler: QuickSeekAnimation?
    
    required init(context: UIObject) {
        super.init(context: context)
        animatonHandler = QuickSeekAnimation(core)
    }
    
    override public func bindEvents() {
        bindCoreEvents()
    }
    
    private func bindCoreEvents() {
        guard let core = core else { return }
        listenTo(core, eventName: Event.didShowModal.rawValue) { [weak self] _ in self?.removeGesture() }
        listenTo(core, eventName: Event.didHideModal.rawValue) { [weak self] _ in self?.addGesture() }
        listenTo(core, eventName: Event.didShowDrawerPlugin.rawValue) { [weak self] _ in self?.removeGesture() }
        listenTo(core, eventName: Event.didHideDrawerPlugin.rawValue) { [weak self] _ in self?.addGesture() }
    }
    
    func removeGesture() {
        NSException(name: NSExceptionName(rawValue: "MissingPluginImplementation"), reason: "QuickSeekPlugin should implement removeGesture method", userInfo: nil).raise()
    }
    
    func addGesture() {
        NSException(name: NSExceptionName(rawValue: "MissingPluginImplementation"), reason: "QuickSeekPlugin should implement addGesture method", userInfo: nil).raise()
    }
    
    override public func render() {
        addGesture()
    }
    
    func shouldSeek(point: CGPoint) -> Bool {
        return true
    }

    @objc func quickSeek(xPosition: CGFloat) {
        guard let activePlayback = activePlayback,
            let container = activeContainer,
            let coreViewWidth = core?.view.frame.width else { return }

        let didTapLeftSide = xPosition < coreViewWidth / 2
        if didTapLeftSide {
            container.trigger(.didDoubleTouchMediaControl, userInfo: ["position": "left"])
            seekBackward(activePlayback)
        } else {
            container.trigger(.didDoubleTouchMediaControl, userInfo: ["position": "right"])
            seekForward(activePlayback)
        }
    }
    
    private func seekBackward(_ playback: Playback) {
        guard playback.playbackType == .vod || playback.isDvrAvailable else { return }
        impactFeedback()
        playback.seek(playback.position - seekDuration)
        guard playback.position - seekDuration > 0.0 else { return }
        animatonHandler?.animateBackward()
        activeContainer?.trigger(InternalEvent.didQuickSeek.rawValue, userInfo: ["duration": -seekDuration])
    }
    
    private func seekForward(_ playback: Playback) {
        guard playback.playbackType == .vod || playback.isDvrAvailable && playback.isDvrInUse else { return }
        impactFeedback()
        playback.seek(playback.position + seekDuration)
        guard playback.position + seekDuration < playback.duration else { return }
        animatonHandler?.animateForward()
        activeContainer?.trigger(InternalEvent.didQuickSeek.rawValue, userInfo: ["duration": seekDuration])
    }
    
    private func impactFeedback() {
        UIImpactFeedbackGenerator().impactOccurred()
    }
}
