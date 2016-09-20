//
//  DemonSpec.swift
//  ArcanaSwift
//
//  Created by Patrick Gleeson on 20/09/2016.
//

import Quick
import Nimble
import ArcanaSwift
import ThinginessSwift

class Tree : BaseThing {

}

class TreeLore: Tome {
    override func registerWords() {
        typeWords["arboria"] = {
            return ThingRegistry.sharedInstance.thingsOfType("Tree")
        }
        selectorWords["minimis"] = { (initialSet) -> ThingSet in
            return initialSet.matching(["size":"small"])
        }
        actionWords["gorgal"] = { (initialSet, refinements) -> () in
            if let sizeModifier = refinements["size"] {
                initialSet.updateAll(["size":sizeModifier])
            }
        }
        refinementWords["grandis"] = ["size":"large"]
    }
}

class DemonSpec: QuickSpec {
    override func spec() {
        describe("cast") {
            it("turns words into a spell") {
                let smallTree = Tree(attributes: ["size":"small"])
                let mediumTree = Tree(attributes: ["size":"medium"])
                let demon = Demon(tomes: [TreeLore()])
                let result = demon.cast("arboria minimis gorgal grandis")
                expect(result).to(beTrue())
                expect(mediumTree.attribute("size")).to(equal("medium"))
                expect(smallTree.attribute("size")).to(equal("large"))
            }
        }
    }
}

