import Quick
import Nimble

@testable import Clappr

class SimpleCorePluginTests: QuickSpec {
    override func spec() {
        describe(".SimpleCorePlugin") {
            context("#init") {
                it("calls bind events") {
                    let core = CoreStub()
                    let simpleCorePlugin = SimpleCoreStubPlugin(context: core)

                    expect(simpleCorePlugin.didCallBindEvents).to(beTrue())
                }

                it("has a non nil core") {
                    let core = CoreStub()
                    let simpleCorePlugin = SimpleCoreStubPlugin(context: core)

                    expect(simpleCorePlugin.core).toNot(beNil())
                }
            }
        }
    }
}

private class SimpleCoreStubPlugin: SimpleCorePlugin {
    var didCallBindEvents = false

    override func bindEvents() {
        didCallBindEvents = true
    }
}
