//
//  EdmondsBlossomTests.swift
//  EdmondsBlossomTests
//
//  Created by Michael Shapiro on 6/8/24.
//

import XCTest
@testable import EdmondsBlossom

final class EdmondsBlossomTests: XCTestCase {
    
    /**
     * Asserts a matching between two vertecies
     */
    func assertMatching(expected: Matching<Int>, output: Matching<Int>) {
        if expected.vertex2 == nil {
            XCTAssertTrue(output.contains(vertex: expected.vertex1.id) && output.vertex2 == nil)
        }
        XCTAssertTrue(output.contains(vertex: expected.vertex1.id) && output.contains(vertex: expected.vertex2!.id))
    }
    
    /**
     * Checks to make sure both outputs match
     */
    func assertMaximumMatching(expected: [Matching<Int>], output: [Matching<Int>]) {
        for i in output {
            XCTAssertTrue(expected.first(where: {$0.contains(vertex: i.vertex1.id) && $0.contains(vertex: i.vertex2!.id)}) != nil)
        }
    }
    
    /**
     * Generates some vertecies
     */
    func generateVertecies(count: Int) -> [Vertex<Int>] {
        var v: [Vertex<Int>] = []
        for i in 1...count {
            v.append(Vertex(id: i, data: i))
        }
        return v
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /**
     * Tests a matching of a graph with no blossoms
     */
    func testGraphNoBlossom() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 4)
        g.addVertex(v: Vertex(id: 1, data: 1))
        g.addVertex(v: Vertex(id: 2, data: 2))
        g.addVertex(v: Vertex(id: 3, data: 3))
        g.addVertex(v: Vertex(id: 4, data: 4))
        
        g.addEdge(v1: Vertex(id: 1, data: 1), v2: Vertex(id: 2, data: 2))
        g.addEdge(v1: Vertex(id: 3, data: 3), v2: Vertex(id: 4, data: 4))
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let completed: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(completed.count == 2)
    }
    
    func testGraphNoBlossom2() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 6)
        let v: [Vertex<Int>] = self.generateVertecies(count: 6)
        for i in v {
            g.addVertex(v: i)
        }
        
        // add edges
        g.addEdge(v1: v[0], v2: v[1])
        g.addEdge(v1: v[1], v2: v[2])
        g.addEdge(v1: v[2], v2: v[3])
        g.addEdge(v1: v[2], v2: v[4])
        g.addEdge(v1: v[4], v2: v[5])
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let completed: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(completed.count == 3)
    }

    /**
     * The first test case with a simple blossom
     */
    func testGraph1() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 4)
        let v1: Vertex<Int> = Vertex(id: 1, data: 1)
        let v2: Vertex<Int> = Vertex(id: 2, data: 2)
        let v3: Vertex<Int> = Vertex(id: 3, data: 3)
        let v4: Vertex<Int> = Vertex(id: 4, data: 4)
        
        g.addVertex(v: v1)
        g.addVertex(v: v2)
        g.addVertex(v: v3)
        g.addVertex(v: v4)
        
        g.addEdge(v1: v1, v2: v2)
        g.addEdge(v1: v1, v2: v3)
        g.addEdge(v1: v2, v2: v3)
        g.addEdge(v1: v3, v2: v4)
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let completed: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(completed.count == 2)
        
        
        let expected: [Matching<Int>] = [Matching(vertex1: v1, vertex2: v2), Matching(vertex1: v3, vertex2: v4)]
        
        self.assertMaximumMatching(expected: expected, output: completed)
    }
    
    func testGraph2() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 10)
        let v: [Vertex<Int>] = self.generateVertecies(count: 10)
        
        for i in v {
            g.addVertex(v: i)
        }
        
        g.addEdge(v1: v[0], v2: v[8])
        g.addEdge(v1: v[0], v2: v[1])
        g.addEdge(v1: v[1], v2: v[2])
        g.addEdge(v1: v[2], v2: v[3])
        g.addEdge(v1: v[3], v2: v[4])
        g.addEdge(v1: v[3], v2: v[7])
        g.addEdge(v1: v[4], v2: v[5])
        g.addEdge(v1: v[5], v2: v[6])
        g.addEdge(v1: v[7], v2: v[6])
        g.addEdge(v1: v[7], v2: v[9])
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let output: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(output.count == 5)
        
        let expected: [Matching<Int>] = [
            Matching(vertex1: v[0], vertex2: v[8]),
            Matching(vertex1: v[2], vertex2: v[1]),
            Matching(vertex1: v[3], vertex2: v[4]),
            Matching(vertex1: v[5], vertex2: v[6]),
            Matching(vertex1: v[7], vertex2: v[9])
        ]
        
        self.assertMaximumMatching(expected: expected, output: output)
    }
    
    /**
     * Tests another graph with blossoms
     */
    func testGraph3() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 6)
        let v: [Vertex<Int>] = self.generateVertecies(count: 6)
        
        for i in v {
            g.addVertex(v: i)
        }
        
        g.addEdge(v1: v[0], v2: v[1])
        g.addEdge(v1: v[0], v2: v[3])
        g.addEdge(v1: v[1], v2: v[2])
        g.addEdge(v1: v[1], v2: v[3])
        g.addEdge(v1: v[1], v2: v[4])
        g.addEdge(v1: v[2], v2: v[4])
        g.addEdge(v1: v[3], v2: v[5])
        g.addEdge(v1: v[3], v2: v[4])
        g.addEdge(v1: v[4], v2: v[5])
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let output: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(output.count == 3)
        
        let expected: [Matching<Int>] = [
            Matching(vertex1: v[0], vertex2: v[3]),
            Matching(vertex1: v[1], vertex2: v[2]),
            Matching(vertex1: v[4], vertex2: v[5])
        ]
        
        self.assertMaximumMatching(expected: expected, output: output)
    }
    /**
     * A bigger graph with blossoms...
     */
    func testGraph4() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 16)
        let v: [Vertex<Int>] = self.generateVertecies(count: 16)
        
        for i in v {
            g.addVertex(v: i)
        }
        
        g.addEdge(v1: v[0], v2: v[1])
        g.addEdge(v1: v[0], v2: v[13])
        g.addEdge(v1: v[1], v2: v[15])
        g.addEdge(v1: v[1], v2: v[4])
        g.addEdge(v1: v[2], v2: v[13])
        g.addEdge(v1: v[2], v2: v[3])
        g.addEdge(v1: v[2], v2: v[6])
        g.addEdge(v1: v[3], v2: v[4])
        g.addEdge(v1: v[3], v2: v[5])
        g.addEdge(v1: v[4], v2: v[5])
        g.addEdge(v1: v[6], v2: v[7])
        g.addEdge(v1: v[7], v2: v[8])
        g.addEdge(v1: v[7], v2: v[14])
        g.addEdge(v1: v[8], v2: v[11])
        g.addEdge(v1: v[8], v2: v[12])
        g.addEdge(v1: v[9], v2: v[10])
        g.addEdge(v1: v[9], v2: v[14])
        g.addEdge(v1: v[10], v2: v[12])
        g.addEdge(v1: v[11], v2: v[12])
        
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let output: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(output.count == 8)
        
        let expected: [Matching<Int>] = [
            Matching(vertex1: v[0], vertex2: v[13]),
            Matching(vertex1: v[1], vertex2: v[15]),
            Matching(vertex1: v[2], vertex2: v[3]),
            Matching(vertex1: v[4], vertex2: v[5]),
            Matching(vertex1: v[6], vertex2: v[7]),
            Matching(vertex1: v[8], vertex2: v[11]),
            Matching(vertex1: v[10], vertex2: v[12]),
            Matching(vertex1: v[9], vertex2: v[14])
        ]
        
        self.assertMaximumMatching(expected: expected, output: output)
    }
    
    /**
     * For testing graphs which don't have any possible matchings
     */
    func testNoMatch() {
        self.continueAfterFailure = false
        var g: Graph<Int> = Graph(vertex_count: 4)
        let v: [Vertex<Int>] = self.generateVertecies(count: 4)
        for i in v {
            g.addVertex(v: i)
        }
        
        // don't add any edges to make this as simple as possible
        let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: g)
        let output: [Matching<Int>] = matching.computeMatchings()
        
        XCTAssertTrue(output.count == 0)
    }
}
