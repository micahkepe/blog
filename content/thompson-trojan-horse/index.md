+++
title = "That Time Ken Thompson Wrote a Backdoor into the C Compiler"
date = 2025-10-16
draft = true

[taxonomies]
categories = ["programming", "compilers"]
tags = ["infosec"]

[extra]
toc = true
+++

When Ken Thompson won the Turing Award jointly with Dennis Ritchie for their
work in UNIX, he was expected like other Turing winners to write a paper that
would be published in the ACM Computer Journal. What he ended up submitting was
a paper about "the cutest program \[he\] ever wrote"-- a sneaky undetectable
self-reproducing "Trojan horse" virus in the C compiler that would allow him to
log into affected machines as any user.

<!-- more -->

{{ youtube(id="OmVHkL0IWk4") }}

## Overview

Thompson didn't want to write about the usual things that Turing award winners
write about— in fact, according to him,[^1] he didn't want to write a paper at
all. However, when he did finally write a paper (after putting it off for a year
past the original deadline), he describes at a high level how the C compiler
(itself a program written in C) parses and compiles C source code into machine
code to set the stage for how the "Trojan horse" would be injected into the
generated machine code while leaving the original input C source code seemingly
unmodified.

He explains that while in college at UC Berkeley, him and colleagues would
"amused [themselves] by posing programming exercises," one of which was "to
write the shortest self-reproducing program":

> More precisely stated, the problem is to write a source program that, when
> compiled and executed, will produce as output an exact copy of its source ...
> The part about "shortest" was just an incentive to demonstrate skill and
> determine a winner.

## The Trojan Horse

In this section, I'll try to illustrate the "Trojan horse" originally presented
by Thompson through the original quasi-C pseudocode.

```c
/* Figure 1 */
char s[] = {
  '\t',
  '0',
  // TODO: fill in the rest of the string
};

/*
  * The string s is a representation of the body of this program from `0` to the
  * end.
*/

main()
{
  int i;

  printf("char\ts[ ] = {\n");
  for (i = 0; s[i]; i++) {
    printf("\t%d,\n", s[i]);
  }
  printf("%s", s);
}
```

```c
/* Figure 2 */
compile(s);
char *s;
{
  // Trojan horse
  if (match(s, "pattern")) {
    compile("bug");
    return;
  }

  // ...
}
```

```c
/* Figure 3.3 */

compile(s);
char *s;
{
  // Trojan horse 1
  if (match(s, "pattern 1")) {
    compile("bug 1");
    return;
  }

  // Trojan horse 2
  if (match(s, "pattern 2")) {
    compile("bug 2");
    return;
  }

  // ...
}
```

## Closing

_What this actually ever distributed in the C compiler?_

In an email from Thompson to an inquirer[^3], Thompson writes:

<pre>
From: Ken Thompson <ken@google.com>
Date: Wed, Sep 28, 2011 at 6:27 PM
Subject: Re: Was compiler from "Reflections" ever built or distributed?
To: Ezra Lalonde <ezra@usefuliftrue.com>

build and not distributed.

On Wed, Sep 28, 2011 at 11:35 AM, Ezra Lalonde <ezra@usefuliftrue.com> wrote:

> Hi Ken,
>
> I've seen various sources on the internet claiming that the "trojan horse"
> compiler you mentioned in your talk "Reflections on Trusting Trust" was
> actually built, and some further claiming that it was distributed.
>
> I'd like to know if these claims are valid.
>
> Thanks for your time.
>
> Cheers,
> Ezra Lalonde
</pre>

So, at least according to Thompson, this never made it out into the wild.
However he also does leave this humorous line in the ACM paper:

> The moral is obvious. You can't trust code that you did not totally create
> yourself. (Especially code from companies that employ people like me.)

## References

[^1]:
    YouTube: [Oral History of Ken
    Thompson](https://www.youtube.com/watch?v=OmVHkL0IWk4&t=15907s) by [Computer
    History Museum](https://www.youtube.com/@ComputerHistory).

    Original inspiration for this post, a great history from the man himself
    describing his life and career from building Ham radios in his youth to his
    time at Bell Labs to his time at Google.

[^2]:
    ["Reflections on Trusting Trust"](https://www.cs.cmu.edu/~rdriley/487/papers/Thompson_1984_ReflectionsonTrustingTrust.pdf)
    Thompson, Ken. “Reflections on Trusting Trust.” Communications of the ACM
    27, no. 8 (1l984): 761–63.
    [https://doi.org/10.1145/358198.358210](https://doi.org/10.1145/358198.358210).

[^3]:
    Skeptics Stack Exchange: ["Was the C compiler trojan horse written by Ken
    Thompson ever
    distributed?"](https://skeptics.stackexchange.com/questions/6386/was-the-c-compiler-trojan-horse-written-by-ken-thompson-ever-distributed)

[^4]:
    The "Unknown Air Force Document" mentioned in Thompson's paper: [Multics Security Evaluation: Vulnerability Analysis](https://web.archive.org/web/20110709024412/http://csrc.nist.gov/publications/history/karg74.pdf).

    A security audit of Multics release in June 1974. In particular, p. 54-55
    outline the "Trojan horse" attack, although it is referred to as a subclass of "trap door" attacks.

[^5]:
    McDermott, J. (1988, October). A technique for removing an important class
    of Trojan horses from high order languages. In Proc. 11th National Computer
    Security Conference (pp. 114-117). [https://apps.dtic.mil/sti/tr/pdf/ADA462303.pdf](https://apps.dtic.mil/sti/tr/pdf/ADA462303.pdf)

    This paper, published in 1988, demonstrates a means of preventing the
    "Trojan horse," as well as outlining some practical issues of implementing
    such a system.
