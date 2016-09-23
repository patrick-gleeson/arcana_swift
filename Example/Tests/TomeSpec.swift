//
//  TomeSpec.swift
//  ArcanaSwift
//
//  Created by Patrick Gleeson on 19/09/2016.
//

import Quick
import Nimble
import ArcanaSwift
import ThinginessSwift

class TestTome: Tome {
    var fooHasBeenInvoked = false
    var barHasBeenInvoked = false
    var harHasBeenInvoked = false
    var thingSet = ThingSet(things: [])

    override func registerWords() {
        typeWords["foo"] = (action: {
            self.fooHasBeenInvoked = true
            return self.thingSet
            }, description: "do the fooey thing")

        selectorWords["bar"] = (action: { (initialSet) -> ThingSet in
            self.barHasBeenInvoked = true
            return self.thingSet
        }, description: "bar")

        actionWords["har"] = (action: { (initialSet, refinements) -> () in
            self.harHasBeenInvoked = true
        }, description: "har")

        refinementWords["mar"] = (action: ["hoo":"har"], description: "mar")
    }
}

class TomeSpec: QuickSpec {
    override func spec() {
        describe("invokeTypeWord") {
            it("invokes the registered word") {
                let testTome = TestTome()
                testTome.invokeTypeWord("foo")
                expect(testTome.fooHasBeenInvoked).to(equal(true))
            }
        }
        describe("invokeSelectorWord") {
            it("invokes the registered word") {
                let testTome = TestTome()
                testTome.invokeSelectorWord("bar", onThingSet: ThingSet(things: []))
                expect(testTome.barHasBeenInvoked).to(equal(true))
            }
        }
        describe("invokeActionWord") {
            it("invokes the registered word") {
                let testTome = TestTome()
                testTome.invokeActionWord("har", onThingSet: ThingSet(things: []), withRefinements: [:])
                expect(testTome.harHasBeenInvoked).to(equal(true))
            }
        }
        describe("invokeRefinementWord") {
            it("invokes the registered word") {
                let testTome = TestTome()
                let result = testTome.invokeRefinementWord("mar")
                expect(result).to(equal(["hoo":"har"]))
            }
        }
        describe("getCategoryOfWord") {
            it("returns the appropriate category if it knows the word") {
                let testTome = TestTome()
                let result = testTome.getCategoryOf("mar")
                expect(result).to(equal(WordCategory.refinement))
            }
            it("returns nothing if it doesn't know the word") {
                let testTome = TestTome()
                let result = testTome.getCategoryOf("far")
                expect(result).to(beNil())
            }
        }
        describe("name") {
            it("returns the name of the class") {
                let testTome = TestTome()
                expect(testTome.name()).to(equal("TestTome"))
            }
        }
        describe("definitions") {
            it("returns a definition for each registered word") {
                let testTome = TestTome()
                expect(testTome.definitions().count).to(equal(4))
            }

            it("returns the name of each word") {
                let testTome = TestTome()
                expect(testTome.definitions()[0].word).to(equal("foo"))
            }

            it("returns the description of each word") {
                let testTome = TestTome()
                expect(testTome.definitions()[0].description).to(equal("do the fooey thing"))
            }
        }

    }
}
