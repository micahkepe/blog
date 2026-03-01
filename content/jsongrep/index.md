+++
title = "jsongrep is faster than:{jq, jmespath, jsonpath-rust, jql}"
date = 2026-02-28
description = "An introduction to the `jsongrep` tool, a technical explanation of its internal search engine, and performance results against popular JSON search too, and performance results against popular JSON search tools."
draft = true

[taxonomies]
categories = ["programming", "cli", "projects"]
tags = ["tools"]

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

## Quick Search Examples

## What is `jsongrep` and Why Should I Use It?

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
    },
    {
      "name": "Bob",
      "favorite_food": "burgers"
    }
  ]
}
```

This document forms the following tree:

$$
  \text{fill me in}
$$

### Performance

Similar to `ripgrep`, `jsongrep` uses deterministic finite automata (DFA) to
achieve faster queries than conventional search engines.

As a consequence, `jsongrep` is fast, like **really fast**:

{{ responsive(
  src="./images/e2e-xlarge.jpg",
  alt="End-to-end search performance comparison over `xlarge` dataset.",
  caption="End-to-end search performance comparison over `xlarge` dataset."
) }}

## `jsongrep` Anti-Pitch

Again borrowing from the `ripgrep` blog post, I would like have an "anti-pitch" for `jsongrep`.

The biggest considerations in my opinion is that it is not as ubiquitous
(_yet_) a tool as say `jq`.

## `jsongrep`'s DFA-Based Query Engine

Fill in with the debug `#[cfg(test)]` output of the constructed NFAs/DFAs and
overview of automata theory concepts

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
