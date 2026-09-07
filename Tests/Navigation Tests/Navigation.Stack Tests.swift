import Navigation
import Testing

@Suite struct `Navigation stacks preserve ordered placements with unique identities` {
    @Suite struct `Navigation stack operations preserve placement order and structural equality` {}
    @Suite struct `Navigation stack failures preserve state and reject duplicate or absent identities` {}
    @Suite struct `No navigation stack integration cases are defined` {}

    enum Screen: Sendable, Hashable {
        case list
        case detail(Int)
        case edit
    }

    struct Placer {
        var source = Navigation.Source()

        mutating func callAsFunction(_ screen: Screen) -> Navigation.Destination<Screen> {
            Navigation.Destination(identity: source.mint(), value: screen)
        }
    }
}

extension `Navigation stacks preserve ordered placements with unique identities`.`Navigation stack operations preserve placement order and structural equality` {
    typealias Screen = `Navigation stacks preserve ordered placements with unique identities`.Screen
    typealias Placer = `Navigation stacks preserve ordered placements with unique identities`.Placer

    @Test func `a new stack holds nothing`() {
        let stack = Navigation.Stack<Screen>()

        #expect(stack.isEmpty)
        #expect(stack.count == 0)
        #expect(stack.top == nil)
    }

    @Test func `push adds above the previous top`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()

        try stack.push(place(.list))
        try stack.push(place(.detail(7)))

        #expect(stack.count == 2)
        #expect(stack.top?.value == .detail(7))
        #expect(stack.first?.value == .list)
    }

    @Test func `pop removes and returns the top`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        try stack.push(place(.list))
        let detail = place(.detail(7))
        try stack.push(detail)

        let popped = stack.pop()

        #expect(popped == detail)
        #expect(stack.count == 1)
        #expect(stack.top?.value == .list)
    }

    @Test func `pop to an earlier placement discards everything above it`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        let list = place(.list)
        try stack.push(list)
        try stack.push(place(.detail(1)))
        try stack.push(place(.edit))

        try stack.pop(to: list.identity)

        #expect(stack.count == 1)
        #expect(stack.top == list)
    }

    @Test func `pop to the current top removes nothing`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        try stack.push(place(.list))
        let edit = place(.edit)
        try stack.push(edit)

        try stack.pop(to: edit.identity)

        #expect(stack.count == 2)
        #expect(stack.top == edit)
    }

    @Test func `contains and destination find a placement by identity`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        let detail = place(.detail(3))
        try stack.push(place(.list))
        try stack.push(detail)

        #expect(stack.contains(detail.identity))
        #expect(stack.destination(detail.identity) == detail)
    }

    @Test func `the sequence initializer preserves bottom-to-top order`() throws {
        var place = Placer()
        let placements = [place(.list), place(.detail(2)), place(.edit)]

        let stack = try Navigation.Stack(placements)

        #expect(Array(stack) == placements)
        #expect(stack.top?.value == .edit)
    }

    @Test func `the same destination visited twice yields two placements`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        let first = place(.detail(9))
        let second = place(.detail(9))
        try stack.push(first)
        try stack.push(second)

        #expect(first.value == second.value)
        #expect(stack.count == 2)

        try stack.pop(to: first.identity)
        #expect(stack.count == 1)
        #expect(stack.top == first)
    }

    @Test func `stacks are values with structural equality`() throws {
        var place = Placer()
        let placements = [place(.list), place(.edit)]
        let left = try Navigation.Stack(placements)
        var right = try Navigation.Stack(placements)

        #expect(left == right)

        _ = right.pop()
        #expect(left != right)
        #expect(left.count == 2)
    }
}

extension `Navigation stacks preserve ordered placements with unique identities`.`Navigation stack failures preserve state and reject duplicate or absent identities` {
    typealias Screen = `Navigation stacks preserve ordered placements with unique identities`.Screen
    typealias Placer = `Navigation stacks preserve ordered placements with unique identities`.Placer

    @Test func `popping an empty stack returns nothing`() {
        var stack = Navigation.Stack<Screen>()

        #expect(stack.pop() == nil)
        #expect(stack.isEmpty)
    }

    @Test func `pushing a duplicate identity throws and leaves the stack untouched`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        let list = place(.list)
        try stack.push(list)
        let clash = Navigation.Destination(identity: list.identity, value: Screen.edit)

        #expect(throws: Navigation.Error.duplicate(list.identity)) {
            try stack.push(clash)
        }

        #expect(stack.count == 1)
        #expect(stack.top == list)
    }

    @Test func `popping to an absent identity throws and leaves the stack untouched`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        try stack.push(place(.list))
        try stack.push(place(.edit))
        let absent = place(.detail(0)).identity

        #expect(throws: Navigation.Error.unknown(absent)) {
            try stack.pop(to: absent)
        }

        #expect(stack.count == 2)
    }

    @Test func `popping to an identity already popped throws`() throws {
        var place = Placer()
        var stack = Navigation.Stack<Screen>()
        try stack.push(place(.list))
        let edit = place(.edit)
        try stack.push(edit)
        _ = stack.pop()

        #expect(throws: Navigation.Error.unknown(edit.identity)) {
            try stack.pop(to: edit.identity)
        }
    }

    @Test func `the sequence initializer rejects duplicate identities`() {
        var place = Placer()
        let list = place(.list)
        let clash = Navigation.Destination(identity: list.identity, value: Screen.edit)

        #expect(throws: Navigation.Error.duplicate(list.identity)) {
            _ = try Navigation.Stack([list, clash])
        }
    }
}
