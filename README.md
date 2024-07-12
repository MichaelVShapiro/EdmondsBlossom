#  EdmondsBlossom

For computing maximal matching of an undirected graph.

## Table of Contents

- About
- How it Works
- Time Complexity
- API Usage

## About

[Edmonds Blossom](https://en.wikipedia.org/wiki/Blossom_algorithm) is a special algorithm invented by Jack Edmonds (back in 1961) that can produce a maximal matching on a graph.

To get a better picture on what I am talking about, assume you had some students to pair up. These students probably gave you a list of people of who they would like to work with for an assignment, and your job is to pair them all up so that everyone has at least one partner (in other words, the matching is maximum).

The Blossom Algorithm can help make these maximal matchings on a [undirected graph](https://www.geeksforgeeks.org/what-is-unidrected-graph-undirected-graph-meaning/). It can maximize the matchings of each vertex.

Most of the implementations of this algorithm are either in python or C++, so I decided to make this implementation in Swift.

## How it Works

Lets go from the start. The algorithm begins by getting all the exposed vertecies -- that is vertecies _which are not matched up_.

The algorithm relies on this concept of [augmenting path](https://stackoverflow.com/questions/10397118/what-exactly-is-augmenting-path) which is a sequence of alternating edges that can help increase the size of matchings done.

Better yet, a visual would be very helpful to check out. During development, I used [this](https://algorithms.discrete.ma.tum.de/graph-algorithms/matchings-blossom-algorithm/index_en.html) fantastic tool to test the implementation, and get a better visual myself of how the algorithm works. First click the "Create a graph" button in the navigation. Then just select any random graph, and press "Ready -- Run the Algorithm!"

You can then play around with the buttons "next" and "fast forward", but most importantly, you can see the augmenting paths in action. You can see how the algorithm picks certain vertecies and uses [BFS](https://en.wikipedia.org/wiki/Breadth-first_search) (breadth first search) to find another exposed vertex. As soon as it finds another one, it alternates the matches, to increase the matching size by 1.

But if you keep clicking "next," you might notice how some of the vertecies disappear all of the sudden, and then reappear at one point.

This is where the algorithm gets fun! While finding the augmenting path, there is a very good chance you might run into a blossom (hence the name of the algorithm!). A blossom is essentially a odd length [cycle](https://www.w3schools.com/dsa/dsa_algo_graphs_cycledetection.php). This can become a problem as we basically cycle our way back to the original (exposed) vertex.

To fix this problem, we get rid of the cycle. We first identify all the vertecies which are a part of the blossom, and then we contract it into one vertex. After that, we recursively apply the searching of augmenting path in the new graph. Once we find a augmenting path, we improve the matchings (by alternating the edges), and then expanding the original blossom.

And this keeps repeating until there are no more augmenting paths. Note that there will be an augmenting path as long as the matching is not yet maximum (i.e. there is at least one more matching we can make on the graph).

During development, I found [this](https://stanford.edu/~rezab/classes/cme323/S16/projects_reports/shoemaker_vare.pdf) pdf which was very helpful to me as I learned about the algorithm to program it.

## Time Complexity

If we were to try a brute force algorithm to find an optimal matching, we would have to compare each edge to each other at least once. And we would have a complexity of **O(2^n)** where n is the number of edges. That could be fine for about 8 vertecies, but have as many as 14 (especially with multiple edges), and your algorithm will be running for a long time...

The Blossom Algorithm, however, can achieve this optimal matching in **O(e \* v^2)** where e is the number of edges and v is the number of vertecies. The PDF I added earlier (at the end of the "How it Works" section) describes more in detail why we have this time complexity.

## API Usage

The rest of this section explains how to use the API I made to run the Blossom Algorithm. You can use the API by downloading the single "blossom.swift" file.

Note that I designed the algorithm to only return the matchings it was able to find. If you, for instance, have an odd number of vertecies (and one obviously shouldn't have a match), in the returned output you will not see that vertex matched.

```swift
// it is assumed that the single "blossom.swift" file is present somewhere, so all the classes and functions are available

// lets make a graph
let some_graph: Graph<Int> = Graph(vertex_count: 4) // we pass in the number of vertecies the graph has

// note that the generic simply specifies the type of data the graph holds. This is useful as all the vertecies can carry different types of data which you can work with
let vertex1: Vertex<Int> = Vertex(id: 1, data: 1) // we give the vertex ID and the data it holds
// the same generic holds for the vertex
// each vertex must have a unique ID. On top of that, you can pass in some custom data for it to hold!
let vertex2: Vertex<Int> = Vertex(id: 2, data: 2)
let vertex3: Vertex<Int> = Vertex(id: 3, data: 3)
let vertex4: Vertex<Int> = Vertex(id: 4, data: 4)

// adding vertecies
some_graph.addVertex(v: vertex1)
some_graph.addVertex(v: vertex2)
some_graph.addVertex(v: vertex3)
some_graph.addVertex(v: vertex4)

// adding edges
some_graph.addEdge(v1: vertex1, v2: vertex2)
some_graph.addEdge(v1: vertex3, v2: vertex4)

// computing maximum matching

let matching: EdmondsBlossom<Int> = EdmondsBlossom(graph: some_graph)
let matchings_done: [Matching<Int>] = matching.computeMatchings() // to get the matchings

for i in matchings_done {
    print(i.vertex1.id)
    print(i.vertex2!.id)
}
```
