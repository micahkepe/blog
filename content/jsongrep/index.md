+++
title = "jsongrep is faster than:{jq, jmespath, jsonpath-rust, jql}"
date = 2026-02-28
description = "An introduction to the `jsongrep` tool, a technical explanation of its internal search engine, and performance results against popular JSON search too, and performance results against popular JSON search tools."
draft = true

[taxonomies]
categories = ["programming", "cli", "projects"]
tags = ["tools", "rust"]

[extra]
toc = true
+++

This article is both an introduction to a tool I have been working on called
[`jsongrep`](https://github.com/micahkepe/jsongrep), as well as a technical
explanation of the internal search engine it uses. I also discuss the
benchmarking strategy used to compare the performance of `jsongrep` against
other JSON path-like query tools and implementations.

Upfront I would like to say that this article is heavily inspired by Andrew
Gallant's amazing [`ripgrep`](https://github.com/BurntSushi/ripgrep) tool, and
his associated blog post ["ripgrep is faster than {grep, ag, git grep, ucg, pt,
sift}"](https://burntsushi.net/ripgrep/).

<!-- more -->

You can install `jsongrep` from [crates.io](https://crates.io/crates/jsongrep):

```bash
cargo install jsongrep
```

Like `ripgrep`, `jsongrep` is cross-platform (binaries available
[here](https://github.com/micahkepe/jsongrep/releases/)) and written in Rust.

## Quick Search Examples

{{ responsive(
  src="./images/jg-quick-examples.png",
  alt="Example of some of jsongrep's search query features in practice.",
  caption="Example of some of jsongrep's search query features in practice."
) }}

---

## `jsongrep` Pitch

`jsongrep` defines a small, intuitive regular language (think regular
expressions) for expressing paths through a JSON document. This allows users to
think in terms of path shapes.

Similar to `ripgrep`, `jsongrep` uses deterministic finite automata (DFA) to
achieve faster queries than conventional search engines.

As a consequence, `jsongrep` is fast, like **really fast**:

{{ responsive(
  src="./images/e2e-xlarge.jpg",
  alt="End-to-end search performance comparison over `xlarge` dataset.",
  caption="End-to-end search performance comparison over `xlarge` dataset."
) }}

## `jsongrep` Anti-Pitch

Again borrowing from the `ripgrep` blog post, here's an "anti-pitch" for
`jsongrep`:

- The biggest considerations in my opinion is that it is not as ubiquitous
  (_yet_) a tool as say `jq`. `jq` is the go-to for JSON querying, filtering,
  and [transductions](https://en.wikipedia.org/wiki/Finite-state_transducer).

- `jsongrep` lacks filters and transduction capabilities, (e.g., taking input
  and transforming via function that maps operations to found values).

- `jsongrep` is new and has not been battle-tested in the wild.

## `jsongrep`'s DFA-Based Query Engine

With the tool overview out of the way, I'd like to go into more detail on the
underlying engine and automata theory techniques that enable it.

### A Refresher on JSON

A quick refresher on JSON from RFC-8259[^1]:

> A JSON value MUST be an object, array, number, or string, or one of
> the following three literal names:
>
> - false
> - null
> - true

In other words, JSON values are recursive data structures that **form a tree**.

For example, the following is a valid JSON document:

```json
{
  "name": "Micah",
  "favorite_drinks": ["coffee", "Dr. Pepper", "Monster Energy"],
  "roommates": [
    {
      "name": "Alice",
      "favorite_food": "pizza"
    }
  ]
}
```

This document forms the following tree:

$$
  \text{fill me in} \\
  \textit{need to dust off my LaTeX skills}
$$

<!-- TODO: make standalone LaTeX artifacts for diagrams -->

The core of the search engine is the following pipeline:

1. The input document or stream is serialized as a AST via [`serde_json_borrow`](https://crates.io/crates/serde_json_borrow).
2. The user's query is parsed as a [`Query`](https://docs.rs/jsongrep/latest/jsongrep/query/ast/enum.Query.html).
3. From the parsed `Query`, we construct first a **nondeterministic** finite
   automaton (NFA) via [Glushkov's construction algorithm](https://en.wikipedia.org/wiki/Glushkov%27s_construction_algorithm).
4. The NFA is determinized into a **deterministic** finite automaton (DFA) via
   [subset construction](https://en.wikipedia.org/wiki/Powerset_construction).
5. We walk the JSON AST and take transition states in the DFA when we hit them,
   accepting the current JSON path/value if the DFA is in an accepting state.

That's a lot of words and concepts, so let's work through each one with a
motivating query example:

With this in mind, let's go through the entire pipeline to see how the engine
handles this case.

### Parsing JSON and the User Query

### Constructing the NFA

### Constructing the DFA from the NFA

Once the DFA is constructed, searching is trivial-- simply traverse the JSON
tree and take state transitions on matches. If during the traversal you arrive
at an accepting state, you have found a match and it can be recorded.

## Benchmarking Methodology

{{ note(body="
There is also more information on benchmarking, including how to reproduce
the results, in the [benches/](https://github.com/micahkepe/jsongrep/tree/main/benches)
directory of the `jsongrep` repository.
") }}

## Future Work

---

## Links

`jsongrep` is entirely open-source, MIT-licensed software.

- GitHub: [link](https://github.com/micahkepe/jsongrep)
- Crates.io: [link](https://crates.io/crates/jsongrep)
- Benchmarking results: [live site](https://micahkepe.com/jsongrep/report/index.html) | [Criterion output](https://github.com/micahkepe/jsongrep/tree/gh-pages)

---

## References

[^1]:
    [RFC-8259: The JavaScript Object Notation (JSON) Data Interchange
    Format](https://datatracker.ietf.org/doc/html/rfc8259)
