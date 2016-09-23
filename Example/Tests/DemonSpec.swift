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
        typeWords["arboria"] = (description: "All the trees", action: {
            return ThingRegistry.sharedInstance.thingsOfType("Tree")
        })
        selectorWords["minimis"] = (description: "All the trees", action: { (initialSet) -> ThingSet in
            return initialSet.matching(["size":"small"])
        })
        actionWords["gorgal"] = (description: "All the trees", action: { (initialSet, refinements) -> () in
            if let sizeModifier = refinements["size"] {
                initialSet.updateAll(["size":sizeModifier])
            }
        })
        refinementWords["grandis"] = (description: "All the trees", action: ["size":"large"])
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

