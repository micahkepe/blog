+++
title = "Bloom Filters: Space-Efficient Probabilistic Data Structures"
date = 2024-05-25
updated = 2024-05-26
draft = false

[taxonomies]
categories = ["theory"]
tags = ["data structures", "algorithms", "theory"]

[extra]
toc = true
+++

In the realm of computer science, efficiency is often the key to solving complex
problems. One elegant solution that stands out for its efficiency is the Bloom
filter. Despite being relatively lesser-known, Bloom filters offer a powerful
method for determining set membership while using minimal space. This post
explores what Bloom filters are, how they work, their applications in various
fields, and compares them with other data structures.

<!-- more -->

## What is a Bloom Filter?

A Bloom filter is a probabilistic data structure designed to efficiently test
whether an element is a member of a set. It can tell you if an element is
definitely not in the set or that it might be in the set. This probabilistic
nature makes Bloom filters incredibly space-efficient, but it also means they
come with a small chance of false positives.

{{ responsive(
    src="bloom-filter.webp",
    width=70,
    alt="Bloom Filter Example"
) }}

<br>

A Bloom filter consists of:

{{ note(body="

- A bit array of size $m$ (initially all bits are set to 0).
- $k$ independent hash functions, each of which maps an element to one of the
  $m$ array positions.
  ")}}

## How Bloom Filters Work

### Insertion

To add an element to the Bloom filter, the element is passed through each of the
$k$ hash functions, resulting in $k$ array positions. The bits at these
positions in the bit array are set to 1. If any of these bits are already set to
1, they remain unchanged.

{{ responsive(
    src="insertion.png",
    alt="Inserting an element into a Bloom filter",
    caption="Above: Inserting an element into a Bloom filter",
    width=80
) }}

<br>

### Querying

To check if an element is in the Bloom filter, the element is hashed using the
same $k$ hash functions to find the $k$ array positions. If all the
corresponding bits in the bit array are 1, the Bloom filter reports that the
element might be in the set. If any of the bits are 0, the element is definitely
not in the set.

{{ responsive(
src="bloom-filter-membership.png",
alt="Querying an element in a Bloom filter",
caption="Above: Querying an element in a Bloom filter"
width=80) }}

<br>

### False Positives

Bloom filters do not store the actual elements, so they can never have false
negatives (i.e., reporting an element is not in the set when it actually is).
However, they can have false positives (i.e., reporting an element is in the set
when it is not). The probability of false positives depends on the size of the
bit array $m$, the number of hash functions $k$, and the number of elements
inserted $n$.

{{ responsive(
    src="bloom-filter-example.png",
    alt="Example of a false positive in a Bloom filter",
    caption="Above: Example of a false positive in a Bloom filter"
) }}

<br>

## Mathematical Insight

The false positive probability $p$ can be approximated by:

{{ note(body="
\\[ p \approx \left(1 - \left(1 - \frac{1}{m}\right)^{kn}\right)^k \\]
")}}

For practical use, choosing the optimal number of hash functions $k$ and the bit
array size $m$ is crucial to minimize the false positive rate.

## Comparing a Bloom Filter with a Hash Set in Python

To demonstrate the practical use of Bloom filters, let's consider a mock
scenario where a Bloom filter is used to check if a URL is malicious. We will
compare Bloom filters and hash sets in terms of space efficiency and the ability
to quickly determine if a URL is in the blacklist.

### Mock Scenario: Checking Malicious URLs

In this scenario, we simulate a web browser that checks if a URL is malicious
using a locally stored Bloom filter or list. The Bloom filter offers a
space-efficient solution, reducing the need for frequent network calls.

- **Bloom Filter**: Efficient in terms of space, but can have false positives.
- **Hash Set**: No false positives, but can be memory-intensive.

### Setup and Explanation

We will simulate a scenario where we have 1 million URLs in a blacklist and
check a large number of URLs to see if they are malicious. This will highlight
the space efficiency of Bloom filters compared to hash sets.

### Bloom Filter

<div style="display: flex; justify-content: center;">
    <iframe 
        height="500px" 
        width="80%" 
        src="https://repl.it/@MicahKepe/BloomFilterMaliciousURLs?lite=true" 
        frameborder="0" 
        allowfullscreen>
    </iframe>
</div>

Here's the results I got when running the Bloom filter simulation:

{{ note(body="
Bloom Filter Insertion Time: 3.457702159881592 seconds

Bloom Filter Query Time: 0.10877871513366699 seconds

False Positives: 121

Memory Usage: 1.14 MB
")}}

### Hash Set

<div style="display: flex; justify-content: center;">
    <iframe 
        height="500px" 
        width="80%" 
        src="https://repl.it/@MicahKepe/HashSetMaliciousURLs?lite=true" 
        frameborder="0" 
        allowfullscreen>
    </iframe>
</div>

Here's the results I got when running the hash set simulation:

{{ note(body="
Hash Set Insertion Time: 0.6073956489562988 seconds

Hash Set Query Time: 0.03299856185913086 seconds

False Positives: 0

Memory Usage: 30.15 MB
")}}

As you can see, the hash set is significantly more memory-intensive compared to
the Bloom filter (**30.15 MB** vs. **1.14 MB**). However, it does not have any
false positives and is faster in terms of insertion and querying times. But,
imagine a scenario where the blacklist is much larger, and the memory usage
becomes a critical factor. This is where Bloom filters shine:

- **Memory Efficiency**: Bloom filters use a fixed amount of space regardless of
  the number of items inserted, making them ideal for applications with limited
  memory resources.
- **Scalability**: As the size of the data set grows, the memory usage of a hash
  set grows linearly, whereas a Bloom filter's memory usage remains constant.
  This makes Bloom filters suitable for very large data sets.
- **Network Latency**: By storing the Bloom filter locally, we can quickly
  determine if a URL might be malicious without frequent network calls, reducing
  latency and improving user experience.

## Pros and Cons of Bloom Filters

### Pros

{{ note(body="

- **Space Efficiency**: Bloom filters use minimal space compared to other data
  structures.
- **Fast Set Membership Tests**: Bloom filters offer constant-time set
  membership tests.
- **Scalability**: The memory usage of a Bloom filter remains constant
  regardless of the number of elements inserted.
- **Reduced I/O Operations**: Bloom filters can reduce disk reads and network
  calls by quickly filtering out non-existent elements.
  ")}}

<br>

### Cons

{{ note(body="

- **False Positives**: Bloom filters can produce false positives, which may not
  be acceptable in certain applications.
- **Optimal Parameters**: Choosing the optimal number of hash functions and bit
  array size is crucial for minimizing false positives.
- **Limited Applications**: Bloom filters are best suited for scenarios where
  false positives are acceptable and space efficiency is critical.

")}}

<br>

### Real-World Case Studies

**Case Study: Using Bloom Filters in Google Bigtable**

Google Bigtable, a distributed storage system for managing structured data, uses
Bloom filters to reduce disk lookups for non-existent rows or columns. By using
Bloom filters, Bigtable can quickly determine if a row or column is absent
without accessing the disk, thereby improving read performance significantly.
This application of Bloom filters showcases their efficiency in handling
large-scale data storage and retrieval systems.

**Case Study: Akamai's Content Delivery Network (CDN)**

Akamai, one of the largest CDNs in the world, uses Bloom filters to quickly
determine if content is cached on their edge servers. By using Bloom filters,
Akamai can minimize the number of cache misses and reduce the latency of serving
content to users. This helps in delivering content more efficiently and improves
the overall performance of the CDN.

**Case Study: Medium Duplicate Story Detection**

Medium, a popular online publishing platform, uses Bloom filters to detect
duplicate stories. When a user submits a new story, Medium checks if the story
is a duplicate by querying a Bloom filter that stores the hashes of previously
submitted stories. This helps in identifying and preventing the publication of
duplicate content, ensuring a better user experience for readers.

**Case Study: Bitcoin's SPV Nodes**

In Bitcoin, Simplified Payment Verification (SPV) nodes use Bloom filters to
track transactions relevant to them without downloading the entire blockchain.
By using Bloom filters, SPV nodes can operate more efficiently with limited
resources, making it feasible for lightweight clients to participate in the
Bitcoin network.

## Conclusion

Bloom filters are a prime example of how probabilistic data structures can offer
powerful solutions to space and time efficiency challenges. By understanding and
implementing Bloom filters, you can enhance the performance of your applications
in scenarios where quick set membership tests are critical. Despite their
simplicity, Bloom filters have found their way into various sophisticated
systems and continue to be a valuable tool in a programmer's toolkit.

## References

- [Bloom Filters and SPV nodes within the bitcoin blockchain](https://tara-annison.medium.com/bloom-filters-and-spv-nodes-within-the-bitcoin-blockchain-66c36ea673f2)
- [Bloom Filter Wikipedia Page](https://en.wikipedia.org/wiki/Bloom_filter)
- [Cloud Bigtable under the hood: How we improved single-row read throughput by 20-50%](https://cloud.google.com/blog/products/databases/cloud-bigtable-improves-single-row-read-throughput-by-up-to-50-percent/)
- [University of Washington Lecture Slides on Bloom Filter Applications](https://courses.cs.washington.edu/courses/cse312/22wi/files/student_drive/9.4.pdf)
- [Bloom Filters – Introduction and Implementation](https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/)
- [System Design: Bloom Filter](https://towardsdatascience.com/system-design-bloom-filter-a2e19dcd4810)
- [Bloom Filter Data Structure: Implementation and Application](https://www.enjoyalgorithms.com/blog/bloom-filter)

{{ utterances() }}
