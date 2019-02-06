import Quick
import Nimble

@testable import Clappr

class DoubleTapMediaControlPluginTests: QuickSpec {
    
    override func spec() {
        describe(".DoubleTapMediaControlPluginTests") {
            var doubleTapPlugin: DoubleTapMediaControlPlugin!
            var core: CoreStub!
            var mediaControl: MediaControl!
            var playButton: PlayButton!
            
            beforeEach {
                core = CoreStub.init(options: [:])
                doubleTapPlugin = DoubleTapMediaControlPlugin(context: core)
                mediaControl = MediaControl(context: core)
                playButton = PlayButton(context: core)
                
                core.addPlugin(mediaControl)
                core.addPlugin(doubleTapPlugin)
                core.addPlugin(playButton)
                
                core.view.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
                
                core.render()
                mediaControl.render()
                doubleTapPlugin.render()
            }
            
            describe("pluginName") {
                it("has a name") {
                    let pluginName = String(describing: DoubleTapMediaControlPlugin.self)
                    expect(doubleTapPlugin.pluginName).to(equal(pluginName))
                }
            }
            
            describe("gesture recognizers") {
                it("has two gestures") {
                    expect(mediaControl.mediaControlView.gestureRecognizers?.count).to(equal(2))
                }
            }
            
            describe("when double tap is triggered") {
                context("and its position is less than half of the view (left)") {
                    it("seeks back 10 seconds") {
                        mediaControl.show()
                        core.playbackMock?.set(position: 20.0)
                        
                        doubleTapPlugin.doubleTapSeek(xPosition: core.view.frame.origin.x)
                        
                        expect(core.playbackMock?.didCallSeek).to(beTrue())
                        expect(core.playbackMock?.didCallSeekWithValue).to(equal(10))
                    }
                }
                
                context("and its position is more than half of the view (right)") {
                    it("seeks forward 10 seconds") {
                        mediaControl.show()
                        core.playbackMock?.set(position: 20.0)
                        
                        doubleTapPlugin.doubleTapSeek(xPosition: core.view.frame.width)
                        
                        expect(core.playbackMock?.didCallSeek).to(beTrue())
                        expect(core.playbackMock?.didCallSeekWithValue).to(equal(30))
                    }
                }
                
                context("and it colides with another UICorePlugin") {
                    it("should not seek") {
                        mediaControl.renderPlugins([playButton])
                        playButton.view.layoutIfNeeded()
                        mediaControl.view.layoutIfNeeded()
                        
                        let shouldSeek = doubleTapPlugin.shouldSeek(point: CGPoint(x: 100, y: 100))
                        
                        expect(shouldSeek).to(beFalse())
                    }
                }
            }
        }
    }
}
