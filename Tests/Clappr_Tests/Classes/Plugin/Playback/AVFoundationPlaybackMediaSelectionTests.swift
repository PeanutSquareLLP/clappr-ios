import Quick
import Nimble
import OHHTTPStubs

@testable import Clappr

class AVFoundationPlaybackMediaSelectionTests: QuickSpec {
    override func spec() {
        describe(".AVFoundationPlaybackMediaSelection") {
            describe("subtitle selection") {
                context("when option is off") {
                    var stubsDescriptor: OHHTTPStubsDescriptor?

                    beforeEach {
                        OHHTTPStubs.removeAllStubs()
                        OHHTTPStubs.onStubMissing(<#T##block: ((URLRequest) -> Void)?##((URLRequest) -> Void)?##(URLRequest) -> Void#>)
                        stubsDescriptor = stub(condition: isHost("clappr.io")   ) { result in
                            let stubPath = OHPathForFile("sample.m3u8", type(of: self))
                            return fixture(filePath: stubPath!, headers: [:])
                        }

                        stubsDescriptor?.name = "StubToHighlineVideo.mp4"
                    }

                    afterEach {
                        OHTTPStubsHelper.removeStub(with: stubsDescriptor)
                    }

                    it("sets characteristic to nil") {
                        let options = [
                            kSourceUrl: "http://clappr.io/highline.mp4",
                            kDefaultSubtitle: "off"
                        ]
                        let avfoundationPlayback = AVFoundationPlayback(options: options)

                        avfoundationPlayback.play()

                        expect(avfoundationPlayback.selectedSubtitle?.language).toEventually(equal(MediaOptionFactory.offSubtitle().language))
                    }
                }
            }
        }
    }
}

private class OHTTPStubsHelper {
    class func removeStub(with descriptor: OHHTTPStubsDescriptor?) {
        guard let descriptor = descriptor else { return }

        print("Removing stub named -> \"\(descriptor.name ?? "NoName")\" with result: \(OHHTTPStubs.removeStub(descriptor))")
    }
}
