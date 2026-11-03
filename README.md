# swift-navigation

Use this package to model where a user is in an app as plain values, with no UI framework: a back stack of placed screens, the identities that tell two visits to the same screen apart, and how a screen is presented. Start from `Navigation.Stack<Value>`, fill it with `Navigation.Destination<Value>` values whose identities come from one `Navigation.Source`, and describe presentation with `Navigation.Presentation`.

## Laws

- A `Navigation.Source` mints consecutive identities starting at its `next` (zero for a fresh source), and `next` is always the identity the following `mint()` returns. A source restored with `init(next:)` resumes from that ordinal.
- A source is a value: a copy mints the same identities as the original, and replaying the same placements from a fresh source reproduces the same identities.
- Identities compare by ordinal alone, so `<` is mint order. Identities from different sources are not distinguished, so uniqueness holds only among identities minted by one source.
- A `Navigation.Stack<Value>` is ordered bottom to top; `top` is the last element and iteration starts at the bottom.
- Identities are unique within a stack, values are not: the same value visited twice is two placements with distinct identities, and lookup and `pop(to:)` go by identity.
- `push` of an identity already in the stack throws `Navigation.Error.duplicate` and leaves the stack unchanged. The sequence initializer pushes in order and throws on the first duplicate.
- `pop(to:)` keeps the named placement and removes everything above it; naming the top removes nothing. An identity not in the stack, including one already popped, throws `Navigation.Error.unknown` and leaves the stack unchanged.
- `pop()` on an empty stack returns `nil`.
- Stacks and destinations are values with structural equality: two stacks are equal when they hold equal destinations in the same order.
- A `Navigation.Presentation` pairs two independent axes, `Navigation.Presentation.Mode` and `Navigation.Presentation.Dismissal`; all four combinations are distinct. `.user` dismissal means the person may dismiss the presentation; `.program` means only the program does.
