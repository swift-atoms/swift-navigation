extension Navigation {

    public struct Destination<Value> {

        public let identity: Navigation.Identity

        public var value: Value

        public init(identity: Navigation.Identity, value: Value) {
            self.identity = identity
            self.value = value
        }
    }
}

extension Navigation.Destination: Swift.Sendable where Value: Swift.Sendable {}

extension Navigation.Destination: Swift.Equatable where Value: Swift.Equatable {}

extension Navigation.Destination: Swift.Hashable where Value: Swift.Hashable {}
