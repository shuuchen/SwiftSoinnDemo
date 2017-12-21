//
//  File.swift
//  SwiftSoinn
//
//  Created by Shuchen Du on 2016/07/11.
//  Copyright © 2016年 Shuchen Du. All rights reserved.
//

import Foundation
import Darwin

class Signal {
    
    var x: Float!
    var y: Float!
    
    var neighbors: [Signal]!
    
    var learningTimes: Int!
    
    var classID: Int!
    
    init(x: Float, y: Float) {
        
        self.x = x
        self.y = y
        
        self.neighbors = [Signal]()
        
        self.learningTimes = 0
        
        self.classID = -1
    }
    
    func removeNeighborByRef(neighbor: Signal) {
        
        for idx in 0..<neighbors.count {
            
            if neighbor === neighbors[idx] {
                
                neighbors.removeAtIndex(idx)
                
                return
            }
        }
    }
}

class Edge {
    
    var from: Signal!
    var to: Signal!
    
    var age: Int!
    
    init(from: Signal, to: Signal) {
        
        self.from = from
        self.to = to
        
        age = 0
    }
}

class Soinn {
    
    var inSignals: [Signal]!
    var outSignals: [Signal]!
    var edges: [Edge]!
    
    let EDGE_AGE_MAX = 100
    let SIGNAL_DELETE_INTERVAL = 500
    let UNCLASSIFIED = -1
    
    var inputNum = 0
    
    init() {
        
        inSignals = [Signal]()
        outSignals = [Signal]()
        edges = [Edge]()
    }
    
    func inputSignal(signal: Signal) {
        
        inputNum++
        
        inSignals.append(signal)
        
        guard outSignals.count > 2 else {
            
            outSignals.append(signal)
            
            return
        }
        
        let winners = getFirstAndSecondWinner(signal)
        
        if isWithinThreshold(winners) {
            
            addEdge(winners.0, to: winners.1)
            
            incrementEdgeAge(winners.0)
            
            incrementLearningTimes(winners.0)
            
            moveSignal(winners.0, signal: signal)
            
            removeDeadEdge()
            
            if inputNum % SIGNAL_DELETE_INTERVAL == 0 {
                
                removeUnnecessarySignal()
                
                classify()
            }
            
        } else {
            
            outSignals.append(signal)
        }
    }

    func classify() {
        
        var id = 0
        
        for s in outSignals {
            
            s.classID = UNCLASSIFIED
        }
        
        for s in outSignals {
            
            guard s.classID == UNCLASSIFIED else {
                
                continue
            }
            
            setClassID(s, id: id)
            
            id++
            
        }
    }
    
    func setClassID(signal: Signal, id: Int) {
        
        guard signal.classID == UNCLASSIFIED else {
            
            return
        }
        
        signal.classID = id
        
        for n in signal.neighbors {
            
            setClassID(n, id: id)
        }
    }
    
    func removeUnnecessarySignal() {
        
        for s in outSignals {
            
            if s.neighbors.count > 1 {
                
                continue
            }
            
            removeSignalByRef(s)
            
            if s.neighbors.count > 0 {
                
                let n = s.neighbors[0]
                
                n.removeNeighborByRef(s)
                
                removeEdgeBySingals(n, to: s)
            }
        }
    }
    
    func removeDeadEdge() {
        
        for e in edges {
            
            if e.age <= EDGE_AGE_MAX {
                
                continue
            }
            
            removeEdgeByRef(e)
            
            let from = e.from
            let to = e.to
            
            from.removeNeighborByRef(to)
            to.removeNeighborByRef(from)
            
            if from.neighbors.count == 0 {
                
                removeSignalByRef(from)
            }
            
            if to.neighbors.count == 0 {
                
                removeSignalByRef(to)
            }
        }
    }
    
    func removeEdgeByRef(edge: Edge) {
        
        for idx in 0..<edges.count {
            
            if edge === edges[idx] {
                
                edges.removeAtIndex(idx)
                
                return
            }
        }
    }
    
    func removeEdgeBySingals(from: Signal, to: Signal) {
        
        for e in edges {
            
            if (e.from === from && e.to === to) || (e.from === to && e.to === from) {
                
                removeEdgeByRef(e)
                
                return
            }
        }
    }
    
    func removeSignalByRef(signal: Signal) {
        
        for idx in 0..<outSignals.count {
            
            if signal === outSignals[idx] {
                
                outSignals.removeAtIndex(idx)
                
                return
            }
        }
    }
    
    func moveSignal(winner: Signal, signal: Signal) {
        
        let learningRate = Float(1.0) / Float(winner.learningTimes)
        let learningRateOfNeighbors = learningRate / Float(100.0)
        
        let dx = signal.x - winner.x
        let dy = signal.y - winner.y
        
        winner.x = winner.x + learningRate * dx
        winner.y = winner.y + learningRate * dy
        
        for n in winner.neighbors {
            
            n.x = n.x + learningRateOfNeighbors * dx
            n.y = n.y + learningRateOfNeighbors * dy
        }
    }
    
    func incrementLearningTimes(winner: Signal) {
        
        winner.learningTimes = winner.learningTimes + 1
    }
    
    func incrementEdgeAge(winner: Signal) {
        
        for n in winner.neighbors {
            
            if let edge = edgeBetween(winner, to: n) {
                
                edge.age = edge.age + 1
            }
        }
    }
    
    func edgeBetween(from: Signal, to: Signal) -> Edge? {
        
        for e in edges {
            
            if (e.from === from && e.to === to) || (e.from === to && e.to === from) {
                
                return e
            }
        }
        
        return nil
    }
    
    func addEdge(from: Signal, to: Signal) {
        
        if let edge = edgeBetween(from, to: to) {
            
            edge.age = 0

        } else {
        
            let edge = Edge(from: from, to: to)
        
            edges.append(edge)
        
            from.neighbors.append(to)
            to.neighbors.append(from)
        }
    }
    
    func isWithinThreshold(firstWinner: Signal, _ secondWinner: Signal, _ firstDistance: Float, _ secondDistance: Float) -> Bool {
        
        let firstThreshold = getSimilarityThreshold(firstWinner)
        let secondThreshold = getSimilarityThreshold(secondWinner)
        
        return firstDistance <= firstThreshold && secondDistance <= secondThreshold
    }
    
    func getSimilarityThreshold(signal: Signal) -> Float {
        
        if signal.neighbors.count == 0 {
            
            var minDistance = FLT_MAX
            
            for s in outSignals {
                
                guard s !== signal else {
                    
                    continue
                }
                
                let distance = euclideanDistance(s, signal2: signal)
                
                if distance < minDistance {
                    
                    minDistance = distance
                }
            }
            
            return minDistance
            
        } else {
            
            var maxDistance = FLT_MIN
            
            for s in signal.neighbors {
                
                let distance = euclideanDistance(s, signal2: signal)
                
                if distance > maxDistance {
                    
                    maxDistance = distance
                }
            }
            
            return maxDistance
        }
    }
    
    func getFirstAndSecondWinner(signal: Signal) -> (Signal, Signal, Float, Float) {
        
        var firstDistance: Float = FLT_MAX
        var secondDistance: Float = FLT_MAX
        
        var firstWinner: Signal!
        var secondWinner: Signal!
        
        for s in outSignals {
            
            let distance = euclideanDistance(s, signal2: signal)
            
            if distance < firstDistance {
                
                secondDistance = firstDistance
                firstDistance = distance
                
                secondWinner = firstWinner
                firstWinner = s
                
            } else if distance < secondDistance {
                
                secondDistance = distance
                secondWinner = s
            }
        }
        
        return (firstWinner, secondWinner, firstDistance, secondDistance)
    }
    
    func euclideanDistance(signal1: Signal, signal2: Signal) -> Float {
        
        let dx = signal1.x - signal2.x
        let dy = signal1.y - signal2.y
        
        return sqrtf(dx * dx + dy * dy)
    }
}
