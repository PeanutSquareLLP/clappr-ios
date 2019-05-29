import Quick
import Nimble

@testable import Clappr

class PlayButtonTests: QuickSpec {
    override func spec() {
        describe(".PlayButton") {
            var coreStub: CoreStub!
            var playButton: PlayButton!

            beforeEach {
                coreStub = CoreStub()
                playButton = PlayButton(context: coreStub)
            }

            describe("Plugin structure") {
                context("#init") {
                    it("is an MediaControlPlugin type") {
                        expect(playButton).to(beAKindOf(MediaControlPlugin.self))
                    }
                }

                context("pluginName") {
                    it("has a name") {
                        expect(playButton.pluginName).to(equal("PlayButton"))
                    }
                }

                context("panel") {
                    it("is positioned in the center panel") {
                        expect(playButton.panel).to(equal(MediaControlPanel.center))
                    }
                }

                context("position") {
                    it("is aligned in the center") {
                        expect(playButton.position).to(equal(MediaControlPosition.center))
                    }
                }
            }

            describe("when a video is loaded") {
                context("and video is vod") {
                    it("shows button") {
                        playButton.render()

                        coreStub.activeContainer?.trigger(Event.stalling.rawValue)

                        expect(playButton.view.isHidden).to(beFalse())
                    }
                }
            }

            context("when click on button") {
                beforeEach {
                    playButton.render()
                }

                context("and enters in background and receive a didPause event") {
                    it("shows play button") {
                        coreStub.activePlayback?.trigger(Event.didPause)

                        expect(playButton.view.isHidden).toEventually(beFalse())
                    }
                }

                context("and a video is paused") {
                    beforeEach {
                        coreStub.playbackMock?.state = .paused
                    }

                    it("calls the playback play") {
                        playButton.button.sendActions(for: .touchUpInside)

                        expect(coreStub.playbackMock?.didCallPlay).to(beTrue())
                    }

                    it("shows play button") {
                        playButton.button.sendActions(for: .touchUpInside)

                        expect(playButton.view.isHidden).toEventually(beFalse())
                    }
                }
            }

            context("when click on button during playback") {
                beforeEach {
                    playButton.render()
                }

                context("and a video is playing") {

                    beforeEach {
                        coreStub.playbackMock?.state = .playing
                    }

                    it("calls the playback pause") {
                        playButton.button.sendActions(for: .touchUpInside)

                        expect(coreStub.playbackMock?.didCallPause).to(beTrue())
                    }

                    it("changes the image to a play icon") {
                        let playIcon = UIImage.fromName("play", for: PlayButton.self)!

                        playButton.button.sendActions(for: .touchUpInside)

                        let currentButtonIcon = (playButton.button.imageView?.image)!
                        expect(currentButtonIcon.isEqual(playIcon)).to(beTrue())
                    }

                    context("and is vod") {
                        it("shows button") {
                            let coreStub = CoreStub()
                            let playButton = PlayButton(context: coreStub)
                            playButton.render()
                            playButton.view.isHidden = true

                            coreStub.activePlayback?.trigger(Event.playing.rawValue)

                            expect(playButton.view.isHidden).to(beFalse())
                        }
                    }
                }

                context("and a video is paused") {

                    beforeEach {
                        coreStub.playbackMock?.state = .paused
                    }

                    it("calls the playback play") {
                        playButton.button.sendActions(for: .touchUpInside)

                        expect(coreStub.playbackMock?.didCallPlay).to(beTrue())
                    }

                    it("changes the image to a pause icon") {
                        let pauseIcon = UIImage.fromName("pause", for: PlayButton.self)!

                        playButton.button.sendActions(for: .touchUpInside)

                        let currentButtonIcon = (playButton.button.imageView?.image)!
                        expect(currentButtonIcon.isEqual(pauseIcon)).to(beTrue())
                    }

                    context("and is vod") {
                        it("shows button") {
                            let coreStub = CoreStub()
                            let playButton = PlayButton(context: coreStub)
                            playButton.render()
                            playButton.view.isHidden = true

                            coreStub.activePlayback?.trigger(Event.didPause.rawValue)

                            expect(playButton.view.isHidden).to(beFalse())
                        }
                    }
                }
            }

            describe("render") {

                it("set's acessibilityIdentifier to button") {
                    playButton.render()

                    expect(playButton.button.accessibilityIdentifier).to(equal("PlayPauseButton"))
                }

                describe("button") {
                    it("adds it in the view") {

                        playButton.render()

                        expect(playButton.view.subviews).to(contain(playButton.button))
                    }

                    it("has scaleAspectFit content mode") {

                        playButton.render()

                        expect(playButton.button.imageView?.contentMode).to(equal(UIView.ContentMode.scaleAspectFit))
                    }
                }

            }

            context("when stalling") {
                it("hides the plugin") {

                    coreStub.activePlayback?.trigger(Event.stalling.rawValue)

                    expect(playButton.view.isHidden).to(beTrue())
                }

                it("hides the plugin") {

                    coreStub.activePlayback?.trigger(Event.playing.rawValue)

                    expect(playButton.view.isHidden).to(beFalse())
                }
            }
        }
    }
}
