+++
title = "Ingenious Algorithms We Take for Granted: PageRank, Spell Checkers, and Shazam"
date = 2024-05-06
draft = false

[taxonomies]
categories = ["theory"]
tags = ["theory", "algorithms"]

[extra]
toc = true
+++

Algorithms are all around us. They are the invisible forces that power our
modern world, from the search engines we use to find information to the social
networks we use to connect with friends and family. In this post, I share some
ingenious algorithms that I have learned about both in courses and through my
own research.

<!-- more -->

## 1. PageRank

When Larry Page and Sergey Brin founded Google in 1998, they revolutionized the
way we search for information on the internet. Their search engine, Google
Search, used a clever algorithm called PageRank to rank web pages based on their
importance and relevance to a user's query. While Google has since developed
more sophisticated algorithms, PageRank remains a fundamental part of their
search engine and understanding how it works can help you better understand how
search engines work.

### History of PageRank

The idea for PageRank came to Larry Page in a dream in 1996 while he was a
graduate student at Stanford University. Page was interested in the problem of
ranking web pages based on their importance and relevance to a user's query. He
realized that the structure of the web could be used to infer the importance of
a page, just like the structure of academic citations could be used to infer the
importance of a research paper.

Page and his advisor, Terry Winograd, began working on a prototype search engine
called BackRub that used a simple version of PageRank to rank web pages. BackRub
was named after its ability to analyze the "back links" pointing to a given web
page. Page and Winograd presented their work at the Seventh International World
Wide Web Conference in 1998, where it was well received by the academic
community.

After the conference, Page teamed up with his friend Sergey Brin to turn BackRub
into a commercial search engine. They renamed the search engine Google (a play
on the word "googol", which means 1 followed by 100 zeros) and incorporated
PageRank as a key part of their ranking algorithm. The rest, as they say, is
history.

### How PageRank Works

PageRank is based on the idea that a web page's importance can be measured by
the number and quality of other pages that link to it. In other words, if many
important pages link to a particular page, then that page must also be
important. Mathematically, PageRank can be expressed as:

{{ note(body="

\\[ PR(p_i) = \frac{1-d}{N} + d \sum_{p_j \in M(p_i)} \frac{PR(p_j)}{L(p_j)} \\]

where:

- $PR(p_i)$ is the PageRank of page $p_i$
- $N$ is the total number of pages
- $d$ is a damping factor (usually set to 0.85), which represents the
  probability that a random surfer will continue clicking on links rather than
  jumping to a random page
- $M(p_i)$ is the set of pages that link to $p_i$
- $L(p_j)$ is the number of outgoing links from page $p_j$

")}}

<br>

The damping factor $d$ is used to prevent pages with many incoming links
("sinks") from having disproportionately high PageRank values since they have no
outgoing links. Without the damping factor, the PageRank values would tend to
concentrate on a small number of pages, leading to a skewed ranking of search
results. You can think of the damping factor as a way to model the behavior of a
random surfer who occasionally jumps to a random page instead of following links
(after a certain number of clicks, the surfer gets bored and jumps to a random
page).

To calculate PageRank, the algorithm starts by assigning an initial PageRank
value to each page (usually $1/N$). Then, it iteratively updates the PageRank
values using the above equation until convergence. The final PageRank values
represent the importance of each page.

For example, consider a simple network of 4 web pages: A, B, C, and D. Suppose
page B has a link to page A, page C has a link to page A, and page D has links
to all three pages like so:

{{ responsive(
src="simple-network.png",
alt="Simple Network Example",
caption="Above: Simple network of 4 web pages: A, B, C, and D"
width=80
) }}

Initially, each page is assigned a PageRank of 0.25. After one iteration, page
A's PageRank is updated as follows:

{{ note(body="

\\[ PR(A) = \frac{1-0.85}{4} + \\]

\\[0.85 \left( \frac{PR(B)}{1} + \frac{PR(C)}{1} +
\frac{PR(D)}{3} \right) \\]

\\[= 0.0375 + 0.85 \left(\frac{0.25}{1} + \frac{0.25}{1} - \frac{0.25}{3}\right) \\]

\\[\boxed{ PR(A) \approx 0.46 }\\]

")}}

After several iterations, the PageRank values converge to stable values that
reflect the importance of each page in the network. The final PageRank values
can then be used to rank the pages in search results.

{{ responsive(
    src="pagerank.gif",
    alt="PageRank Calculation Example",
    caption="Above: PageRank GIF showing the iterative calculation of
        PageRank values for a simple network of web pages"
    width=70
) }}

One interesting property of PageRank is that it is a Markov chain, which means
that the PageRank values can be interpreted as the probability of a random
surfer landing on a particular page after clicking on links for a long time.
This interpretation has led to some interesting applications of PageRank beyond
web search, such as modeling the spread of disease or analyzing the structure of
social networks.

### Fun Facts about PageRank

- The original PageRank algorithm was inspired by the way academic papers are
  cited by other papers. Just as an academic paper's importance can be measured
  by the number and quality of papers that cite it, a web page's importance can
  be measured by the number and quality of pages that link to it.
- In the early days of Google, the PageRank algorithm was run on a cluster of
  cheap Linux computers. On display at Stanford University is the original
  Google server rack, made from Lego bricks.
- PageRank has been used to rank everything from web pages to scientific papers
  to social media influencers. In fact, there are even "PageRank for people"
  algorithms that try to measure the importance and influence of individuals
  based on their social connections.

---

## 2. Spell Checkers

Have you ever wondered how spell checkers work? How do they know when you've
misspelled a word and suggest the correct spelling? The answer lies in a clever
algorithm called the Levenshtein distance algorithm.

### History of Spell Checkers

The history of spell checkers dates back to the early days of computing. In
1957, a team of researchers at Bell Labs developed a program called
"TypoCorrect" that could detect and correct typing errors in text. However,
TypoCorrect was limited to a small vocabulary and could only correct errors that
were one letter off from the correct spelling.

In the 1960s and 1970s, researchers began to develop more sophisticated spell
checkers that could handle larger vocabularies and more complex errors. One of
the first practical spell checkers was developed by Ralph Gorin at Stanford
University in 1971. Gorin's spell checker used a dictionary of 10,000 words and
could suggest corrections for misspelled words.

In the 1980s, spell checkers became more widely available as part of word
processing software. The first spell checker for the IBM PC was developed by
Mark Skapinker and released in 1981. Microsoft Word, which was first released in
1983, included a built-in spell checker that quickly became a standard feature
of word processing software.

Today, spell checkers are ubiquitous and can be found in everything from email
clients to social media apps. Modern spell checkers use sophisticated algorithms
and machine learning techniques to detect and correct spelling errors in
real-time.

### How Spell Checkers Work

At the core of most spell checkers is the Levenshtein distance algorithm, which
measures the similarity between two strings. The Levenshtein distance between
two strings is defined as the minimum number of single-character edits
(**insertions**, **deletions**, or **substitutions**) required to transform one
string into the other.

For example, the Levenshtein distance between "kitten" and "sitting" is 3,
because we can transform "kitten" into "sitting" with the following edits:

1. **k**itten → **s**itten (substitution of "s" for "k")
2. sitt**e**n → sitt**i**n (substitution of "i" for "e")
3. sittin → sittin**g** (insertion of "g" at the end)

The Levenshtein distance algorithm can be implemented using dynamic programming.
Let $d(i, j)$ be the Levenshtein distance between the first $i$ characters of
string $s_1$ and the first $j$ characters of string $s_2$. Then, $d(i, j)$ can
be calculated using the following recurrence relation:

{{ note(body="

$$
d(i, j) =
\begin{cases}
\max(i, j) & \text{if } \min(i, j) = 0 \newline
\min \begin{cases}
d(i-1, j) + 1 \newline
d(i, j-1) + 1 \newline
d(i-1, j-1) + 1*{s_1[i] \neq s_2[j]}
\end{cases} & \text{otherwise}
\end{cases}
$$

where $1*{s_1[i] \neq s_2[j]}$ is an indicator function that is 1 if the $i$-th
character of $s_1$ is not equal to the $j$-th character of $s_2$, and 0
otherwise.
")}}

To check the spelling of a word, a spell checker typically compares the word to
a dictionary of correctly spelled words using the Levenshtein distance
algorithm. If the Levenshtein distance between the word and its closest match in
the dictionary is below a certain threshold, the spell checker assumes the word
is correctly spelled. Otherwise, it suggests the closest match(es) as possible
corrections.

One interesting variant of the Levenshtein distance algorithm is the
Damerau-Levenshtein distance, which allows for transpositions of adjacent
characters in addition to insertions, deletions, and substitutions. This variant
is useful for catching common typing errors like "teh" instead of "the".

### Fun Facts about Spell Checkers

- The first spell checker was developed for the Unix operating system and was
  called "spell". It used a simple algorithm that compared each word to a
  dictionary of correctly spelled words.
- Early spell checkers were notoriously bad at handling proper nouns and
  technical jargon. Modern spell checkers use more sophisticated techniques,
  such as machine learning, to improve their accuracy.
- Some spell checkers can even catch homophones (words that sound the same but
  are spelled differently), such as "their" vs. "there" vs. "they're".
- Spell checkers have been used for more than just correcting spelling errors.
  In 2018, researchers at the University of Michigan developed a spell checker
  that could detect signs of Alzheimer's disease in writing samples by looking
  for subtle changes in language use over time.
- The Levenshtein distance algorithm has applications beyond spell checking,
  such as DNA sequence alignment and plagiarism detection.

---

## 3. Shazam

Have you ever heard a song playing and wondered what it was called or who sang
it? Shazam is a popular app that can identify songs based on a short audio clip.
The algorithm behind Shazam is ingenious in its simplicity and effectiveness.

### History of Shazam

The idea for Shazam came to co-founder Chris Barton in 1999 when he was a
student at the University of California, Berkeley. Barton was at a bar with
friends and heard a song he liked but didn't know the name of. He thought it
would be great if there was a way to identify songs using a phone.

Barton teamed up with Avery Wang, a PhD student in audio signal processing, to
develop the algorithm behind Shazam. Wang had previously worked on a system for
identifying bird songs based on their spectrograms, and he realized that a
similar technique could be used to identify music.

Barton and Wang founded Shazam in 2000 and launched the first version of the app
in 2002. At the time, the app could only identify a small number of songs and
required users to call a special phone number and hold their phone up to the
music. However, the app quickly gained popularity and began to expand its
database of songs.

In 2008, Shazam launched an iPhone app that allowed users to identify songs
directly from their phone. This version of the app used the phone's built-in
microphone to capture the audio and send it to Shazam's servers for
identification. The iPhone app was a huge success and helped to drive Shazam's
growth.

Today, Shazam is one of the most popular music recognition apps in the world,
with over 1 billion downloads and 20 million song identifications per day. In
2018, Shazam was acquired by Apple for a reported $400 million.

### How Shazam Works

At a high level, Shazam works by converting an audio clip into a "fingerprint"
that can be compared to a database of known songs. The fingerprint is created
using a clever algorithm called the spectrogram peak finding algorithm.

Here's how it works:

1. The audio clip is divided into short overlapping segments (called "frames")
   and the frequency spectrum of each frame is calculated using the Fast Fourier
   Transform (FFT).
2. The spectrogram (a visual representation of the frequency spectrum over time)
   is analyzed to identify "peaks" (local maxima) in the frequency domain. These
   peaks correspond to the dominant frequencies in the audio clip.
3. The time and frequency coordinates of each peak are combined to create a
   "hash" (a unique identifier) for that peak.
4. The hashes for all the peaks in the clip are combined to create a fingerprint
   for the clip.
5. The fingerprint is compared to a database of fingerprints for known songs
   using a technique called "combinatorial hashing".
6. If a match is found, the song is identified and returned to the user.

The key insight behind Shazam is that the spectrogram peaks are robust to noise
and distortion, so they can be used to identify songs even in noisy environments
or when the audio quality is poor.

{{ responsive(
src="spectrogram.png",
alt="Spectrogram of 'Blurred Lines' by Robin Thicke",
caption="Above: Spectrogram of 'Blurred Lines' by Robin Thicke."
width=80
) }}

For example, suppose you're at a noisy bar and hear a song playing that you want
to identify. You open up Shazam and record a 10-second clip of the song. Shazam
then converts the clip into a spectrogram and identifies the peaks.

The peaks are then hashed and combined into a fingerprint, which is compared to
Shazam's database of over 11 million songs. Even though the clip is noisy and
distorted, Shazam is still able to find a match and identify the song.

{{ responsive(
    src="signal-match.png",
    alt="Signal Matching in Shazam",
    caption="Above: Signal matching in Shazam."
    width=80
) }}

One interesting aspect of Shazam's algorithm is that it uses a technique called
"combinatorial hashing" to efficiently search its database of song fingerprints.
Combinatorial hashing works by dividing the fingerprint into smaller
subfingerprints and searching for matches for each subfingerprint separately.
This allows Shazam to identify songs quickly even though its database contains
millions of songs.

{{ responsive(
    src="shazam.png",
    alt="Shazam Process",
    caption="Above: Excerpt from Shazam's patent showing the process of
        identifying a song."
) }}

<br>

### Fun Facts about Shazam

- Shazam's database contains over 11 million songs and is growing every day.
- Shazam has been used to identify over 50 billion songs since its launch
  in 2002.
- The most Shazamed song of all time is "Dance Monkey" by Tones and I, which has
  been identified over 36.6 million times.
- Shazam's algorithm can identify a song in as little as 1 second, even if the
  audio quality is poor or there is background noise.
- Shazam's co-founder Avery Wang is also an accomplished classical pianist and
  has performed at Carnegie Hall.

---

## Conclusion

These are just a few examples of the many ingenious algorithms that power our
modern world. From search engines to spell checkers to music recognition apps,
algorithms are all around us, working behind the scenes to make our lives easier
and more efficient. As technology continues to advance, we can expect to see
even more clever algorithms emerge to solve new problems and challenges.

The next time you use a search engine to find information, correct a spelling
mistake, or identify a song, take a moment to appreciate the algorithms that
make it all possible. They may be invisible, but they are the unsung heroes of
the digital age.

## References

\-
[Larry Page's University of Michigan commencement address](https://www.youtube.com/watch?v=qFb2rvmrahc)
\
\- [Google’s PageRank: The Math Behind the Search Engine](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=33566b740d3cd0c0dde57e13b5da148bef37376f)
\
\- [The Anatomy of a Large-Scale Hypertextual Web Search Engine](http://infolab.stanford.edu/~backrub/google.html)
\
\- [PageRank GIF Source](https://www.youtube.com/watch?v=meonLcN7LD4) \
\- [The Levenshtein-Damerau Distance](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance)
\
\- [Shazam: An Industrial-Strength Audio Search Algorithm](https://www.ee.columbia.edu/~dpwe/papers/Wang03-shazam.pdf)
\
\- [How on Earth Does Shazam Recognize Songs](https://youtu.be/ev0Ay1m4MWs?si=C_Bk31NOsUeRVAPN)
\
\- [How does Shazam Uniquely Identify A Track?](https://networkedlifeq21.fandom.com/wiki/How_does_Shazam_Uniquely_Identify_A_Track%3F)

{{ utterances()}}
