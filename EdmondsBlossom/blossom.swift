//
//  blossom.swift
//  EdmondsBlossom
//
//  Created by Michael Shapiro on 6/8/24.
//

import Foundation

/**
 * For storing vertex data
 */
struct Queue<T: Any> {
    
    /**
     * Main queue
     */
    private var q: [T] = []
    
    /**
     * Enqueues data
     */
    mutating func enqueue(data: T) {
        self.q.append(data)
    }
    
    /**
     * Dequeues data
     */
    mutating func dequeue() -> T? {
        if self.q.count == 0 {
            return nil
        }
        return self.q.remove(at: 0)
    }
    
    /**
     * Determines if the queue is empty
     */
    func isEmpty() -> Bool {
        return self.q.isEmpty
    }
    
    /**
     * Peeks at the first element in the queue
     */
    func peek() -> T? {
        if self.q.count == 0 {
            return nil
        }
        
        return self.q[0]
    }
}

/**
 * A stack
 */
struct Stack<T: Any> {
    
    /**
     * Main stack
     */
    private var s: [T] = []
    
    /**
     * Adds an item to the stack
     */
    mutating func push(data: T) {
        self.s.append(data)
    }
    
    /**
     * Removes an item from the stack
     */
    mutating func pop() -> T? {
        if s.isEmpty {
            return nil
        }
        return s.removeLast()
    }
    
    /**
     * Peeks at the last item in the stack
     */
    func peek() -> T? {
        return s.last
    }
    
    /**
     * Determines if the stack is empty
     */
    func isEmpty() -> Bool {
        return s.isEmpty
    }
}

// set up a interface for identifying vertecies more easily

/**
 * For easy vertex identification
 */
protocol VertexIdentifiable {
    
    /**
     * Vertex ID. This should be unique
     */
    var id: Int { get }
}

//MARK: GENERAL STRUCTURES INITIALIZATION

struct Vertex<T: Any>: VertexIdentifiable, Hashable {
    static func == (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    var id: Int // as needed
    
    /**
     * The data the vertex holds
     */
    let data: T
    
    /**
     * The hash value can simply represent the id
     */
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

/**
 * A simple forest which would store the important variables when computing maximum matching
 */
struct Forest<T: Any> {
    /**
     * This is what is going to help the bfs
     * It returns the parent of each vertex
     */
    var parent_vertex: Dictionary<Int, Vertex<T>> = Dictionary()
    /**
     * This returns the root vertex of each vertex in the bfs tree
     */
    var root_vertex: Dictionary<Int, Vertex<T>> = Dictionary()
    /**
     * This helps compute the distance from the root vertex to another vertex
     */
    var vertex_distance: Dictionary<Int, Int> = Dictionary()
}

/**
 * A single matching between two vertecies
 */
struct Matching<T: Any> {
    
    /**
     * The first vertex of matching
     */
    var vertex1: Vertex<T>
    /**
     * Second vertex for matching
     */
    var vertex2: Vertex<T>? // can be nil if there are an odd number of vertecies
    
    /**
     * Determines if the matching contains the vertex with the given id
     */
    func contains(vertex: Int) -> Bool {
        if self.vertex1.id == vertex {
            return true
        }
        
        if self.vertex2 == nil {
            return false
        }
        
        return self.vertex2!.id == vertex
    }
    
    /**
     * Gets the matched vertex in the matching
     */
    func getMatched(v: Vertex<T>) -> Vertex<T>? {
        // it is assumed vertex2 is not nil
        if self.vertex1.id != v.id && self.vertex2!.id != v.id {
            return nil
        }
        
        if self.vertex1.id == v.id {
            return self.vertex2!
        }
        
        return self.vertex1
    }
}

/**
 * A graph
 */
struct Graph<T: Any> {
    
    /**
     * Number of vertecies in graph
     */
    let vertex_count: Int
    /**
     * Adjacency matrix for the graph
     */
    private var matrix: [[Int]] = []
    /**
     * For O(1) access to the indexes of the matrix for each vertex
     */
    private var reserved_index: Dictionary<Int, Int> = Dictionary()
    /**
     * Vertecies added
     */
    private var added_vertecies: [Vertex<T>] = []
    /**
     * Latest index to assign for a vertex
     */
    private var reserved_i: Int = 0
    
    init(vertex_count: Int) {
        self.vertex_count = vertex_count
        
        // reserve this count for matrix
        self.matrix = [[Int]](repeating: [Int](repeating: 0, count: vertex_count), count: vertex_count)
    }
    
    /**
     * Adds a vertex to the graph
     */
    mutating func addVertex(v: Vertex<T>) {
        // make sure the count has not yet been exceeded
        if self.reserved_i == self.vertex_count {
            return
        }
        // reserve index
        self.reserved_index[v.id] = self.reserved_i
        self.reserved_i += 1
//        self.matrix[self.reserved_i - 1] = []
        // reserve capacity as necessary
//        self.matrix[self.reserved_i - 1].reserveCapacity(self.vertex_count)
        self.added_vertecies.append(v)
    }
    
    /**
     * Adds an edge to two vertecies
     */
    mutating func addEdge(v1: Vertex<T>, v2: Vertex<T>) {
        // make sure both vertecies exist in the graph
        if self.reserved_index[v1.id] == nil || self.reserved_index[v2.id] == nil {
            return
        }
        
        self.matrix[self.reserved_index[v1.id]!][self.reserved_index[v2.id]!] = 1
        self.matrix[self.reserved_index[v2.id]!][self.reserved_index[v1.id]!] = 1
    }
    
    /**
     * Gets the matrix for vertecies
     */
    func getMatrix() -> [[Int]] {
        return self.matrix
    }
    
    /**
     * Returns all vertecies added
     */
    func getVerteciesAdded() -> [Vertex<T>] {
        return self.added_vertecies
    }
    
    /**
     * Gets the edges for a given vertex
     */
    func getEdgesForVertex(v: Vertex<T>) -> [Vertex<T>] {
        // make sure vertex exists in graph
        if self.reserved_index[v.id] == nil {
            return []
        }
        var edges: [Vertex<T>] = []
        
        // go through and check which edges are marked
        for i in self.matrix[self.reserved_index[v.id]!].enumerated() {
            if i.element == 1 {
                edges.append(self.added_vertecies[i.offset])
            }
        }
        
        return edges
    }
}

//MARK: BLOSSOM ALGORITHM CORE

/**
 * The core algorithm
 */
class EdmondsBlossom<T: Any> {
    
    /**
     * The graph being held
     */
    let graph: Graph<T>
    
    /**
     * For storing different matchings as blossoms are contracted
     */
    private var match_stack: Stack<[Matching<T>]> = Stack()
    /**
     * For keeping track of blossom roots as different matchings are made accross the graph
     */
    private var blossom_root_stack: Stack<Vertex<T>> = Stack()
    /**
     * For keeping track of blossom vertecies as different matchings are made accross the graph
     */
    private var blossom_vertecies_stack: Stack<[Vertex<T>]> = Stack()
    /**
     * To keep track of the original graphs of each blossom
     */
    private var blossom_graph_original: Stack<Graph<T>> = Stack()
    
    /**
     * The root of a vertex
     */
    private var node_root: Dictionary<Int, Vertex<T>> = Dictionary()
    
    init(graph: Graph<T>) {
        self.graph = graph
    }
    
    /**
     * Gets all the exposed vertecies in the graph
     * - Parameters:
     *  - matching: Required. The current matchings done
     */
    private func getExposedVertecies(matching: [Matching<T>]) -> Queue<Vertex<T>> {
        // vertecies are considered to be exposed if they don't have a matching
        var exposed: Queue<Vertex<T>> = Queue()
        
        // to speed up the process of checking for exposed vertecies, generate a dictionary for quick finding
        var vertecies_matched: Dictionary<Int, Bool> = Dictionary()
        for i in matching {
            vertecies_matched[i.vertex1.id] = true
            if i.vertex2 == nil {
                // unlikely to happen
                continue
            }
            vertecies_matched[i.vertex2!.id] = true
        }
        
        // loop through all the vertecies and check if they exist in the matching
        for i in self.graph.getVerteciesAdded() {
            if vertecies_matched[i.id] ?? false {
                // not exposed
                continue
            }
            exposed.enqueue(data: i)
        }
        
        return exposed
    }
    /**
     * Applies the matchings given an augmenting path
     */
    private func applyMatchings(augmenting_path: [Matching<T>], matchings: UnsafeMutablePointer<[Matching<T>]>) {
        // remove all nodes in augmenting path from matchings
        var mm: [Matching<T>] = augmenting_path
        for i in matchings.pointee {
            if mm.contains(where: {$0.contains(vertex: i.vertex1.id) || $0.contains(vertex: i.vertex2!.id)}) {
                continue
            }
            mm.append(i)
        }
        matchings.pointee = mm
    }
    
    /**
     * Returns the augmenting path
     */
    private func returnAugmentingPath(forest: Dictionary<Int, Vertex<T>>, v: Vertex<T>, w: Vertex<T>) -> [Matching<T>] {
        var path1: [Matching<T>] = []
        var v1: Vertex<T> = v
        // connect each vertex in the augmenting path together
        // stop until we reach v as that will be matched with w
        while forest[v1.id]!.id != v1.id {
            path1.append(Matching(vertex1: v1, vertex2: forest[v1.id]!))
            v1 = forest[v1.id]!
        }
        
        // reverse for adding root of augmenting path for w
        path1.reverse()
        
        var v2: Vertex<T> = w
        var path2: [Matching<T>] = []
        // apply same operation for w as done to v
        while forest[v2.id]!.id != v2.id {
            path2.append(Matching(vertex1: v2, vertex2: forest[v2.id]!))
            v2 = forest[v2.id]!
        }
        
        // combine the full path and match v and w
        let total: [Matching<T>] = path1 + [Matching(vertex1: v, vertex2: w)] + path2
        var temp: [Matching<T>] = []
        
        // apply matchings to temp for returning
        // since the paths retrieved earlier contain duplicates, we must skip every one match in the total every time to get the proper matchings
        var i: Int = 0
        while i < total.count {
            temp.append(total[i])
            i += 2
        }
        
        return temp
    }
    /**
     * Gets the path of a cycle
     */
    private func getPath(v: Vertex<T>, parent: Dictionary<Int, Vertex<T>>) -> [[Vertex<T>]] {
        var path: [[Vertex<T>]] = []
        
        var vv: Vertex<T> = v
        
        // go through the entire blossom until we hit the same vertex twice
        // this will get all the vertecies part of the blossom
        while parent[vv.id]!.id != vv.id {
            path.append([vv, parent[vv.id]!])
            vv = parent[vv.id]!
        }
        
        return path
    }
    /**
     * Contracts a blossom and returns the derivative graph
     */
    private func contractBlossom(graph_given: Graph<T>, parent: Dictionary<Int, Vertex<T>>, matchings: [Matching<T>], v: Vertex<T>, w: Vertex<T>) -> Graph<T> {
        // we first need to know how many new vertecies will be in the new graph
        // so get all the vertecies in the blossom
        var blossom_vertecies: [Vertex<T>] = []
        
        // get paths
        var pathv: [[Vertex<T>]] = self.getPath(v: v, parent: parent).reversed()
        var pathw: [[Vertex<T>]] = self.getPath(v: w, parent: parent).reversed()
        
        // reverse paths
        pathw = pathw.map({$0.reversed()})
        pathv = pathv.map({$0.reversed()})
        
        // remove any duplicates at the start of both pathw and pathv
        while pathv.count > 0 && pathw.count > 0 && pathv[0][0].id == pathw[0][0].id && pathv[0][1].id == pathw[0][1].id {
            pathv.removeFirst()
            pathw.removeFirst()
        }
        
        // combine to form the edges and determine the vertecies
        let blossom_edges: [[Vertex<T>]] = pathv + [[v, w]] + pathw.reversed()
        
        // make the vertecies from the edges
        for i in blossom_edges {
            for z in i {
                blossom_vertecies.append(z)
            }
        }
        
        // the root of the blossom is the first vertex
        let blossom_root: Vertex<T> = blossom_vertecies[0]
        
        blossom_vertecies.removeAll(where: {$0.id == blossom_root.id})
        
        blossom_vertecies = [blossom_root] + blossom_vertecies
        
        // strip duplicates off blossom vertecies
        var dupbv: Set<Vertex<T>> = Set()
        var dup: [Vertex<T>] = []
        
        for i in blossom_vertecies {
            if dupbv.contains(i) {
                continue
            }
            dupbv.insert(i)
            dup.append(i)
        }
        blossom_vertecies = dup
        
        let new_vertex_count: Int = graph_given.vertex_count - blossom_vertecies.count + 1
        var derivative_graph: Graph<T> = Graph(vertex_count: new_vertex_count)
        
        // add all new vertecies
        let old_vertecies: [Vertex<T>] = graph_given.getVerteciesAdded()
        for i in old_vertecies {
            // make sure we don't add any vertecies that were in the blossom
            if blossom_vertecies.contains(where: {$0.id == i.id}) {
                continue
            }
            derivative_graph.addVertex(v: i)
        }
        
        // add vertex representing blossom
        derivative_graph.addVertex(v: blossom_root)
        
        // add edges
        for i in old_vertecies {
            // skip any vertecies in blossom
            if dupbv.contains(i) {
                continue
            }
            for z in graph_given.getEdgesForVertex(v: i) {
                // any edge connecting to the blossom will connect to the contract blossom
                if blossom_vertecies.contains(where: {$0.id == z.id}) {
                    derivative_graph.addEdge(v1: i, v2: blossom_root)
                } else {
                    derivative_graph.addEdge(v1: i, v2: z)
                }
            }
        }
        
        // also contract matchings
        // remove all vertecies part of the blossom
        let mm: [Matching<T>] = matchings // represents m' (matching derivative)
        
        // add to match stack for usage
        self.match_stack.push(data: mm)
        
        // also add blossom root to stack
        self.blossom_root_stack.push(data: blossom_root)
        
        // also add blossom vertecies
        self.blossom_vertecies_stack.push(data: blossom_vertecies)
        
        // also add graph, it could be useful
        self.blossom_graph_original.push(data: graph_given)
        
        return derivative_graph
    }
    /**
     * Lifts the blossom
     */
    private func liftBlossom(augmenting_path: [Matching<T>]) -> [Matching<T>] {
        // first remove derivative match
        let _ = self.match_stack.pop()!
        let blossom_root: Vertex<T> = self.blossom_root_stack.pop()!
        let blossom_vertecies: [Vertex<T>] = self.blossom_vertecies_stack.pop()!
        let graph_old: Graph<T> = self.blossom_graph_original.pop()!
        
        // now find all vertecies which are matched up with the root of the blossom
        var connected_vertecies: [Vertex<T>] = []
        for i in augmenting_path {
            if i.contains(vertex: blossom_root.id) {
                connected_vertecies.append(i.getMatched(v: blossom_root)!)
            }
        }
        
        // check if anything was connected to the blossom
        if connected_vertecies.count == 0 {
            // we don't have to lift anything
            return augmenting_path
        }
        
        // re construct augmenting paths by adding all supernodes into the augmenting path
        // we can start with the root node
        var augmenting_path_fixed: [Matching<T>] = augmenting_path
        // remove all nodes connected to root of blossom
        augmenting_path_fixed.removeAll(where: {$0.contains(vertex: blossom_root.id) && $0.contains(vertex: connected_vertecies[0].id)})
        var connected: Matching<T>? = nil
        // this can be achieved by finding an augmenting path in the blossom
        // so construct a new graph to achieve this
        var blossom_graph: Graph<T> = Graph(vertex_count: blossom_vertecies.count + connected_vertecies.count)
        var blossom_nodes: Set<Int> = Set() // for preventing duplicates
        // add all blossom vertecies to the "blossom graph"
        // also insert into the blossom nodes
        for i in blossom_vertecies {
            blossom_graph.addVertex(v: i)
            blossom_nodes.insert(i.id)
        }
        // add any connected vertecies to the graph as well and the blossom nodes
        for i in connected_vertecies {
            blossom_graph.addVertex(v: i)
            blossom_nodes.insert(i.id)
        }
        // go through all connected vertecies again but this time add only edges which connect to any nodes in the blossom
        for i in connected_vertecies {
            for z in graph_old.getEdgesForVertex(v: i) {
                // only add edges to blossom vertecies
                if blossom_nodes.contains(z.id) {
                    // if nothing is already connected to the vertex, connect the vertex to it
                    if connected == nil {
                        connected = Matching(vertex1: i, vertex2: z)
                    }
                    blossom_graph.addEdge(v1: i, v2: z)
                }
            }
        }
        // also add edges in the blossom vertecies
        for i in blossom_vertecies {
            // also only add edges which are in the actual blossom
            for z in graph_old.getEdgesForVertex(v: i) {
                if blossom_nodes.contains(z.id) {
                    blossom_graph.addEdge(v1: i, v2: z)
                }
            }
        }
        // we can use the same blossom algorithm for finding the new matchings in the blossom
        let em: EdmondsBlossom<T> = EdmondsBlossom(graph: blossom_graph)
        let m: [Matching<T>] = em.computeMatchings(graph_given: blossom_graph, matchings: [connected!])
        // add to augmenting path
        augmenting_path_fixed += m
        return augmenting_path_fixed
    }
    
    /**
     * Finds an augmenting path for a given vertex
     */
    private func findAugmentingPath(graph_given: Graph<T>, matchings: [Matching<T>]) -> [Matching<T>] {
        
        // get all exposed vertecies
        var exposed_vertecies: Queue<Vertex<T>> = self.getExposedVertecies(matching: matchings)
        if exposed_vertecies.isEmpty() {
            return []
        }
        var exposed_vertecies_copy: Queue<Vertex<T>> = exposed_vertecies // just a copy
        
        // set up forest
        var forest: Forest<T> = Forest()
        
        // add all exposed vertecies to forest
        while !exposed_vertecies.isEmpty() {
            let node: Vertex<T> = exposed_vertecies.dequeue()!
            forest.parent_vertex[node.id] = node
            forest.root_vertex[node.id] = node
            forest.vertex_distance[node.id] = 0 // set to 0 as there is no distance from root to root!
        }
        
        var visited_nodes: Set<Int> = Set() // visited vertecies
        let a = exposed_vertecies_copy.dequeue()!
        exposed_vertecies_copy = Queue()
        exposed_vertecies_copy.enqueue(data: a)
        
        // go through entire queue of exposed vertecies to improve the matching
        while !exposed_vertecies_copy.isEmpty() {
            // get exposed vertex
            let exposed_vertex: Vertex<T> = exposed_vertecies_copy.dequeue()!
            
            // make sure vertex was never visited
            if visited_nodes.contains(exposed_vertex.id) {
                continue // already visited!
            }
            
            // get all edges
            let edges: [Vertex<T>] = graph_given.getEdgesForVertex(v: exposed_vertex)
            
            // go through all edges
            for i in edges {
                // make sure edge has not already been visited
                if visited_nodes.contains(i.id) {
                    continue
                }
                // check if the edge is in the forest
                if forest.vertex_distance[i.id] == nil {
                    // neighboring vertex is in matching
                    forest.parent_vertex[i.id] = exposed_vertex
                    forest.vertex_distance[i.id] = forest.vertex_distance[exposed_vertex.id]! + 1
                    forest.root_vertex[i.id] = forest.root_vertex[exposed_vertex.id]!
                    
                    // also add neighboring vertex the neighbored vertex is matched up too
                    let n: Matching<T> = matchings.first(where: {$0.contains(vertex: i.id)})!
                    let nn: Vertex<T> = n.getMatched(v: i)!
                    
                    forest.parent_vertex[nn.id] = i
                    forest.vertex_distance[nn.id] = forest.vertex_distance[i.id]! + 1
                    forest.root_vertex[nn.id] = forest.root_vertex[i.id]!
                    
                    // add neighboring vertex to bfs queue
                    exposed_vertecies_copy.enqueue(data: nn)
                } else {
                    // check distance
                    if forest.vertex_distance[i.id]! % 2 == 0 {
                        // check for blossoms
                        if forest.root_vertex[exposed_vertex.id]!.id != forest.root_vertex[i.id]!.id {
                            // no blossom
                            return self.returnAugmentingPath(forest: forest.parent_vertex, v: exposed_vertex, w: i)
                        }
                        
                        // blossom found!
                        // contract blossom first
                        let derivative_graph: Graph<T> = self.contractBlossom(graph_given: graph_given, parent: forest.parent_vertex, matchings: matchings, v: exposed_vertex, w: i)
                        // find new augmenting path
                        let aug_path: [Matching<T>] = self.findAugmentingPath(graph_given: derivative_graph, matchings: self.match_stack.peek()!)
                        // lift the blossom
                        return self.liftBlossom(augmenting_path: aug_path)
                    }
                    // else do nothing!
                }
                // mark edge visited
                visited_nodes.insert(i.id)
            }
        }
        
        return [] // no augmenting path found!
    }
    
    private func computeMatchings(graph_given: Graph<T>, matchings: [Matching<T>]) -> [Matching<T>] {
        // as long as matching is max there is a augmenting path
        let augmenting_path: [Matching<T>] = self.findAugmentingPath(graph_given: graph_given, matchings: matchings)
        if augmenting_path.count == 0 {
            // we are done
            return matchings
        }
        // continue until there are no more augmenting paths
        var mm: [Matching<T>] = matchings
        self.applyMatchings(augmenting_path: augmenting_path, matchings: &mm)
        return self.computeMatchings(graph_given: graph_given, matchings: mm)
    }
    
    /**
     * Removes all duplicates from the matchings
     */
    private func stripDuplicates(matchings: [Matching<T>]) -> [Matching<T>] {
        var m: [Matching<T>] = []
        var check: Set<String> = Set()
        
        for i in matchings {
            let mm: Int = min(i.vertex1.id, i.vertex2!.id)
            let ma: Int = max(i.vertex1.id, i.vertex2!.id)
            
            let h: String = "\(mm)_\(ma)"
            if check.contains(h) {
                continue
            }
            check.insert(h)
            
            m.append(i)
        }
        
        return m
    }
    
    /**
     * Computes the maximum matching
     */
    public func computeMatchings() -> [Matching<T>] {
        self.stripDuplicates(matchings: self.computeMatchings(graph_given: self.graph, matchings: []))
    }
}
