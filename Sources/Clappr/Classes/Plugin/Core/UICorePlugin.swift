open class UICorePlugin: ActiveCorePlugin, UIPlugin {
    var uiObject = UIObject()
    
    public var view: UIView {
        get {
            return uiObject.view
        } set(newValue) {
            return uiObject.view = newValue
        }
    }
    
    open func render() {
        NSException(name: NSExceptionName("RenderNotOverriden"), reason: "UICorePlugins should always override the render method").raise()
    }
}
