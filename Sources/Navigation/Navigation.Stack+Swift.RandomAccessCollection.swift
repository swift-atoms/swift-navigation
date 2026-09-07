extension Navigation.Stack: Swift.RandomAccessCollection {

    public typealias Element = Navigation.Destination<Value>

    public typealias Index = Int

    public var startIndex: Int { placed.startIndex }

    public var endIndex: Int { placed.endIndex }

    public subscript(position: Int) -> Navigation.Destination<Value> {
        placed[position]
    }
}
