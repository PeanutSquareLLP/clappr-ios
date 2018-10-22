open class Loader {

    static let shared = Loader()
    var plugins: [String: Plugin.Type] = [:]

    var playbacks: [Plugin.Type] {
        return plugins.filter { $0.value.type == .playback }.map { return $0.value }
    }

    var containerPlugins: [Plugin.Type] {
        return plugins.filter { $0.value.type == .container }.map { return $0.value }
    }

    var corePlugins: [Plugin.Type] {
        return plugins.filter { $0.value.type == .core }.map { return $0.value }
    }

    private init() {
        Logger.logInfo("plugins:" +
            "\n - playback: \(playbacks.map({ $0.name }))" +
            "\n - container: \(containerPlugins.map({ $0.name }))" +
            "\n - core: \(corePlugins.map({ $0.name }))")
    }
    
    open func addExternalPlugins(_ externalPlugins: [Plugin.Type]) {
        externalPlugins.forEach { plugin in
            self.plugins[plugin.name] = plugin
        }
    }

}
