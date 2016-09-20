//
//  Demon.swift
//  Pods
//
//  Created by Patrick Gleeson on 20/09/2016.
//
//

import ThinginessSwift

public class Demon {
    private var tomes: Array<Tome>

    public init(tomes: Array<Tome>) {
        self.tomes = tomes
    }
    
    public func cast(spell: String) -> Bool {
        do {
            var wordDataArray = try createWordDataArray(spell)
            var semanticBlocks = try createSemanticBlocks(wordDataArray)
            try invokeAll(semanticBlocks)
            return true
        } catch ArcaneError.UnrecognizedWord {
            return false
        } catch ArcaneError.IncomprehensibleOrder {
            return false
        } catch {
            return false
        }
    }

    private func createWordDataArray(spell: String) throws -> Array<WordData> {
        var words = spell.componentsSeparatedByString(" ")
        return try words.map { word in
            guard let tome = getTomeFor(word) else {
                throw ArcaneError.UnrecognizedWord
            }
            return WordData(category: tome.getCategoryOf(word)!, word: word, tome: tome)
        }
    }

    private func getTomeFor(word: String) -> Tome? {
        var ret:Tome? = nil
        for tome in tomes {
            guard let _ = tome.getCategoryOf(word) else {
                continue
            }
            ret = tome
            break
        }
        return ret
    }

    private func createSemanticBlocks(wordDataArray: Array<WordData>) throws -> Array<SemanticBlock> {
        var ret = Array<SemanticBlock>()
        for wordData in wordDataArray {
            switch wordData.category {
            case .type:
                ret.append(SemanticBlock(blockType: BlockType.object, wordData: wordData, auxiliaryWords: []))
            case .action:
                ret.append(SemanticBlock(blockType: BlockType.verb, wordData: wordData, auxiliaryWords: []))
            default:
                guard var last = ret.popLast() else {
                    throw ArcaneError.IncomprehensibleOrder
                }
                last.auxiliaryWords.append(wordData)
                ret.append(last)
            }
        }
        return ret
    }

    private func invokeAll(semanticBlocks: Array<SemanticBlock>) throws {
        var lastObjectInvocationResult:ThingSet? = nil
        for semanticBlock in semanticBlocks {
            switch semanticBlock.blockType {
            case .object:
                lastObjectInvocationResult = try invokeObjectBlock(semanticBlock)
            case .verb:
                guard let invokedObjects = lastObjectInvocationResult else {
                    throw ArcaneError.IncomprehensibleOrder
                }
                try invokeVerbBlock(semanticBlock, objects: invokedObjects)
            }
        }
    }

    private func invokeObjectBlock(objectBlock: SemanticBlock) throws -> ThingSet {
        var ret = objectBlock.wordData.tome.invokeTypeWord(objectBlock.wordData.word)
        for selector in objectBlock.auxiliaryWords {
            guard selector.category == WordCategory.selector else {
                throw ArcaneError.IncomprehensibleOrder
            }
            ret = selector.tome.invokeSelectorWord(selector.word, onThingSet: ret)
        }
        return ret
    }

    private func invokeVerbBlock(verbBlock: SemanticBlock, objects: ThingSet) throws {
        var refinements:[String:String] = [:]
        for refinement in verbBlock.auxiliaryWords {
            guard refinement.category == WordCategory.refinement else {
                throw ArcaneError.IncomprehensibleOrder
            }

            for(k, v) in refinement.tome.invokeRefinementWord(refinement.word) {
                refinements.updateValue(v, forKey: k)
            }
        }

        verbBlock.wordData.tome.invokeActionWord(verbBlock.wordData.word, onThingSet: objects, withRefinements: refinements)
    }
}
