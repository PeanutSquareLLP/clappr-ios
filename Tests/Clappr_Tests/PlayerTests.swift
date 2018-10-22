import Quick
import Nimble
import AVFoundation

@testable import Clappr

class PlayerTests: QuickSpec {
    static let specialSource = "specialSource"
    
    override func spec() {
        describe(".Player") {
            let options: Options = [kSourceUrl: "http://clappr.com/video.mp4"]
            var player: Player!
            var playback: Playback!

            context("#init") {
                context("when listening Playback events") {
                    var callbackWasCalled = false

                    beforeEach {
                        self.resetPlugins()
                        player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])
                        playback = player.activePlayback
                        callbackWasCalled = false
                    }

                    it("calls a callback function to handle ready event") {
                        player.on(.ready) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.ready)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle error event") {
                        player.on(.error) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.error)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle didComplete event") {
                        player.on(.didComplete) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.didComplete)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle didPause event") {
                        player.on(.didPause) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.didPause)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle didStop event") {
                        player.on(.didStop) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.didStop)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle stalled event") {
                        player.on(.stalled) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.stalled)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle bufferUpdate event") {
                        player.on(.bufferUpdate) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.bufferUpdate)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle positionUpdate event") {
                        player.on(.positionUpdate) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.positionUpdate)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle airPlayStatusUpdate event") {
                        player.on(.airPlayStatusUpdate) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.airPlayStatusUpdate)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle willPlay event") {
                        player.on(.willPlay) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.willPlay)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle playing event") {
                        player.on(.playing) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.playing)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle willPause event") {
                        player.on(.willPause) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.willPause)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle willStop event") {
                        player.on(.willStop) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.willStop)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle willSeek event") {
                        player.on(.willSeek) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.willSeek)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle seek event") {
                        player.on(.seek) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.seek)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle didSeek event") {
                        player.on(.didSeek) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.didSeek)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle subtitleSelected event") {
                        player.on(.subtitleSelected) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.subtitleSelected)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle audioSelected event") {
                        player.on(.audioSelected) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.audioSelected)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle requestFullscreen event") {
                        player.on(.requestFullscreen) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.requestFullscreen)

                        expect(callbackWasCalled).to(beTrue())
                    }

                    it("calls a callback function to handle exitFullscreen event") {
                        player.on(.exitFullscreen) { _ in
                            callbackWasCalled = true
                        }
                        playback.trigger(.exitFullscreen)

                        expect(callbackWasCalled).to(beTrue())
                    }
                }

                context("core dependency") {
                    it("is initialized") {
                        let player = Player(options: options)
                        expect(player.core).toNot(beNil())
                    }

                    it("has active container") {
                        let player = Player(options: options)
                        expect(player.core?.activeContainer).toNot(beNil())
                    }
                }

                context("external playbacks") {
                    it("sets external playback as active") {
                        self.resetPlugins()
                        player = Player(options: options, externalPlugins: [StubPlayback.self])
                        playback = player.activePlayback

                        expect(player.activePlayback).to(beAKindOf(StubPlayback.self))
                    }

                    it("changes external playback based on source") {
                        self.resetPlugins()
                        player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])
                        playback = player.activePlayback

                        player.load(PlayerTests.specialSource)

                        expect(player.activePlayback).to(beAKindOf(SpecialStubPlayback.self))
                    }
                }

                context("plugins in loader") {
                    it("pass only player plugins to loader") {
                        self.resetPlugins()

                        player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])

                        expect(Loader.shared.plugins.count).to(equal(5))
                    }

                    it("pass third party plugins to loader") {
                        self.resetPlugins()

                        Player.register(plugin: LoggerPlugin.self)
                        player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])

                        expect(Loader.shared.plugins.count).to(equal(6))
                    }

                    it("ignore plugins registered after player initialization") {
                        self.resetPlugins()
                        player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])

                        Player.register(plugin: LoggerPlugin.self)

                        expect(Loader.shared.plugins.count).to(equal(5))
                    }
                }
            }
            
            describe("#configure") {
                it("changes Core options") {
                    self.resetPlugins()
                    player = Player(options: options, externalPlugins: [SpecialStubPlayback.self, StubPlayback.self])
                    player.configure(options: ["foo": "bar"])

                    let playerOptionValue = player.core?.options["foo"] as? String
                    
                    expect(playerOptionValue).to(equal("bar"))
                }
            }
        }
    }

    private func resetPlugins() {
        Loader.shared.resetPlugins()
        Player.appPlugins = []
    }
    
    class StubPlayback: Playback {
        override var pluginName: String {
            return "StubPlayback"
        }
        
        override class func canPlay(_: Options) -> Bool {
            return true
        }
    }
    
    class SpecialStubPlayback: Playback {
        override var pluginName: String {
            return "SpecialStubPlayback"
        }
        
        override class func canPlay(_ options: Options) -> Bool {
            return options[kSourceUrl] as! String == PlayerTests.specialSource
        }
    }

    class LoggerPlugin: UICorePlugin {
        override var pluginName: String { return "Logger" }

        required init(context: UIBaseObject) {
            super.init(context: context)
            bindEvents()
        }

        required init() {
            super.init()
        }

        required init?(coder argument: NSCoder) {
            super.init(coder: argument)
        }

        private func bindEvents() {
            stopListening()
            bindPlaybackEvents()
        }

        private func bindPlaybackEvents() {
            if let core = self.core {
                listenTo(core, eventName: InternalEvent.didChangeActivePlayback.rawValue) {  (_: EventUserInfo) in
                    print("Log didChangeActivePlayback!!!!")
                }
            }
        }
    }
}
