+++
title = "I Switched to a Split Keyboard: Here's Why"
date = 2025-01-21
draft = false

[taxonomies]
categories = ["tools"]
tags = ["keyboard"]

[extra]
toc = true
+++

I've ditched my traditional keyboard for a split keyboard. Here's why I made the
switch and how I'm finding it so far.

<!-- more -->

# Why?

A few months ago I stumbled upon a YouTube video[^1] that would start off this whole
chain of events.

{{
    youtube(id="7UXsD7nSfDY")
}}

This seriously is an amazing video and I recommmend giving it a watch. It's a
great introduction to the world of custom keyboards and the rabbit hole that
comes with it.

## The Issues with the Standard QWERTY Keyboard

The main issues with the standard QWERTY keyboard can be summarized with the
following:

### Diagonal Columns

The keys on a standard QWERTY keyboard are arranged in diagonal columns. This
is an artifact of the typewriter days when the keys were arranged in this way
to prevent the jamming of the mechanical keys. This is no longer an issue with
modern keyboards that use electrical switches, but the design stayed.

> **Aside**: If you've spent time tinkering with Vim. you might have noticed that
> the Enter key is often called `<CR>` for "carriage return," which is another
> artifact of the typewriter days.

As a consequence of this holdover, keys like B are a huge stretch on modern
keyboards, which makes proper touch typing difficult as you'll most likely need
to take your hands off the home row to reach these keys or resort to using
non-standard finger placements.

### Modifier Keys Placement

The modifier keys (Ctrl, Option, Command, etc.) are placed in the corners of
the board, making it nearly impossible to keep your fingers on the homerow
while using them. This is especially frustrating for Vim users, as the Ctrl key
is used in many keybindings as well as basic Vim built in commands like
navigating up and down the page with `Ctrl+U` and `Ctrl+D`.

### Hand Position and Ergonomics

Standard keyboards force our wrists and hands into unnatural positions that
can lead to repetitive strain injuries (RSI) over time. The main issues include:

- **Ulnar Deviation**: Our wrists are forced to bend outward to align with the keyboard
- **Wrist Extension**: Many keyboards, especially non-mechanical ones, require lifting our wrists
- **Shoulder Tension**: Hands are typically held closer together than shoulder width
- **Finger Stretching**: Reaching for numbers and symbols often requires awkward stretches

A split keyboard addresses these issues by allowing each half to be
positioned at shoulder width and angled to maintain neutral wrist position.

# The Piantor

After watching quite a few YouTube videos and reading a lot of blog posts, I
settled on the
[Piantor keyboard](https://shop.beekeeb.com/product/pre-soldered-piantor-split-keyboard/).
The main reasons I chose this board were:

- **42 keys**: This seemed like a good balance of portability and compactness with
  enough fumctionality overlap with a standard full-sized QWERTY keyboard that
  would make the board(s) super easy to take around and make it so that when I did
  need to use a full-sized keyboard, I wouldn't be completely lost.
- **wired**: I wanted a wired keyboard to avoid the hassle of charging and from the
  research I did, it seems that wired keyboards are more reliable than wireless
- **great shop**: Leo at BeeKeeb really is super helpful and responsive. The shop
  is only a two-man operation in Hong Kong, so it's nice to support a small business
  that does great work
- **pre-built**: I briefly considered building my own keyboard, but I decided that
  I wanted to get a pre-built one to avoid the hassle of soldering and flashing
  firmware.

With that out of the way, I placed my order and waited for the board to arrive.

# First Thoughts with the Board and Dialing It In

{{ responsive(
    src="images/piantor.jpg",
    width=70,
    alt="The Piantor keyboard",
    caption="The Piantor keyboard. As you can see, it is a split keyboard with
    42 keys."
) }}

The initial setup of any split keyboard requires patience. There's a
significant learning curve, but the ergonomic benefits make it worthwhile.
Here's my journey:

## Initial Challenges

My preview WPM dropped to a snail's pace. The main challenges were:

- Adapting to the columnar layout instead of staggered keys
- Learning to use layers effectively
- Training my thumbs to do more than just hit the spacebar
- Getting comfortable with home row mods

## Configuring the Keyboard with QMK

The most common firmware for custom keyboards are [QMK](https://qmk.fm/) and
[ZMK](https://zmkfirmware.dev/). QMK is the most popular firmware for custom
wire keyboards, while ZMK is a newer firmware that supports wireless keyboards.
Because I'm using a wired keyboard, I'll be using QMK.

### Layers

The board comes with a default layer mapping, but I quickly realized that I
would need to change it to fit how I work.

As I do a lot of work in the terminal, especially in Neovim and Tmux sessions,
I wanted to prioritize the `ESCAPE`, `Enter`, `Ctrl`, and `Option` as I use these
for tons of keymaps and navigating around.

#### The Base Layer: QWERTY + Thumb Keys

{{ responsive(
    src="images/base-layer.png",
    width=70,
    alt="Base layer of the split keyboard",
    caption="The base layer of the split keyboard. As you can see, it is mostly
    a standard QWERTY layout exceot for the home row mods and the thumb keys."
) }}

The base layer had the least amount of customization done. Ignore the `TD` keys
for now, we'll go over those more in the section on home row mods. The main
thing to see is that with the base layter, the keyboard is essentially a 42-key
bord that you can use to type in QWERTY, plus the thumb keys.

The thumb keys are one of the most powerful aspects of this layout. Our
thumbs are naturally strong and dexterous, yet on traditional keyboards, they'
re relegated to just hitting the spacebar. On the Piantor, I've configured my
thumb keys to handle space, enter, and layer switching - tasks that
traditionally required awkward pinky stretches or hand movement.

#### The First Layer: Numbers and Symbols

{{ responsive(
    src="images/layer-1.png",
    width=70,
    alt="First layer of the split keyboard",
    caption="The first layer of the split keyboard. This is where I am able to
    access my numbers and symbols."
) }}

This is where things start to get a little more spicy.

On my left hand, I have access to numbers, a period for writing floating point
numnbers, and the `Shift` state of the normal number row.

On the right side, I have all of the symbols remaining from the board, with the
top row being the rest of the `Shift` values of the normal number row and the
rest of my symbols like `()`, ` {}`, etc. This definitely took a lot of time to
get used to, but soon muscle memory took over.

#### The Second Layer: Function Keys and Special Keys

{{ responsive(
    src="images/layer-2.png",
    width=70,
    alt="Second layer of the split keyboard",
    caption="The second layer of the split keyboard. This is where I am able to
    access my function keys and other special keys."
) }}

One of my favorite aspects of this layer is the arrow key placement. They map
directly to the Vim movement keys (HJKL), which means I'm using the same
spatial memory I've built up from Vim. This makes navigation incredibly
smooth and intuitive - there's no cognitive overhead of learning new
positions since they perfectly align with movements I already know.

### Karabiner-Elemments: Making the Keyboard Work with macOS

I found that I needed to use [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
to retain some of the functionality that I had with my old keyboard. The main
source of frustration was from the Mac media keys not working with the Piantor
keyboard[^2]. I was able to fix this by simply just using Karabiner-Elements without
any additional configuration, which I'm sure exactly that fixed the issue, but
if it ain't broke, don't fix it. My guess is that by default my Macbook is
interpreting the media keys as function keys, so I just had to make sure that
the media keys were being used instead of the function keys.

### Home Row Mods: Making the Most Out of 42 keyboards

Returing to those `TD` keys, these refer to "tap dance" keys, which are keys
that can be configured to do different things depending on how long you hold
them down. In my case, I've configured them to be home row modifiers.

Home row mods are when you configure your homerow keyts to act as modifiers when
held down. This is a great way to keep your fingers on the home row while still
having access to all the modifier keys you need. I have found that I prefer this
setup way more than the traditional modifier key placement and that I am looking
to carry this over to my laptop keyboard as well.

There are many different layouts[^3],[^4] of the modifiers that are possible, however I
settled on the following, which I believe gibves me a good balance of the keyt
as a MacOS user who frequently uses all of these keys often in combination:

**Left hand modifiers:**

- A: Ctrl when held
- S: Alt when held
- D: GUI (Command) when held
- F: Shift when held

**Right hand modifiers:**

- J: Shift when held
- K: GUI (Command) when held
- L: Alt when held
- ;: Ctrl when held

This setup provides several advantages:

1. Your fingers never leave the home row to access modifiers
2. The modifiers are symmetrically arranged, making them easier to remember
3. The strongest fingers (index and middle) control the most commonly used modifiers
4. Every modifier is accessible without any stretching or hand contortion

The learning curve for home row mods is steep - it took me about two weeks to
stop accidentally triggering modifiers while typing normally. The key is to
adjust the tapping term (how long you need to hold a key for it to register
as a hold rather than a tap) to find your sweet spot. In my configuration, I've
set this to 150ms, which provides a good balance between preventing
accidental activations and maintaining quick access to the modifiers.

I also made the right middle thumb key have a tap dance as well where when I tap
it is the `Esc` key and when I hold it toggles the second layer. This is something
that I found really convenient when working in Vim since I use the `Esc` key so often
when switching modes.

For a way better overview and explanatiohn of home row mods I highly recommend
checking out this [blog post by precondition](https://precondition.github.io/home-row-mods).[^5]

{{ note(body="
As an aside, while I think Karabiner-Elements is a great tool, I think that
[KMonad](https://github.com/kmonad/kmonad) is a better tool for configuring home row
mods on the default Mac laptop keyboard if you wanted your home row mods to carry
over to the laptop keyboard as well.
"
)}}

### Learning Tools: Retraining Muscle Memory

Switching to a split keyboard meant essentially relearning how to type. Here are the tools that helped me make the transition:

- **[Keybr](https://www.keybr.com/)**: This was invaluable for relearning proper touch typing. The
  adaptive algorithm helped me focus on problematic keys and gradually build up speed without developing bad habits.

- **[MonkeyType](https://monkeytype.com/)**: Once I had the basics down, MonkeyType helped me work on
  speed and accuracy. Its clean interface and variety of text options kept
  practice sessions engaging.

- **[KeyCastr](https://github.com/keycastr/keycastr)**: This visual key
  display tool was crucial for debugging my typing. Being able to see my
  keystrokes in real-time helped me catch mistakes and verify I was using the
  correct keys, especially when working with different layers.

> **Tip**: If you're making the switch, I recommend starting with Keybr to
> build proper fundamentals, then graduating to MonkeyType for speed training.
> Keep KeyCastr running initially to catch any layer or modifier key mistakes.

# Conclusion: Is it Worth It?

**It depends**. If you're looking for a new hobby and are willing to spend a lot of
time and the money on a keyboard, then I think it could potentially be a good choice.

Personally, I love the uniqueness of the board, the customization options, and
overall the smoothness and tactility of the experience. Just from the short time
that I have been using this board I've noticed:

- My touch typing has significantly improved
- Absolutely no wrist pain, which I would sometimes get from prolonged coding
  sessions in the past.
- Much more enjoyable typing experience overall (some "shiny object syndrome" is
  definitely at play too here)
- Rarely having to use my mouse anymore as I just began using keyboard shortcuts
  for everything such as navigating around my Brave browser, which has native
  keyboard navigation shortcuts like `Space` to page down, since all of my modifier
  keys are now so easily accessible from either my home row or thumbs.

Honestly, if you've already drank the Kool-Aid with Vim... this is just the next
step on your journey to becoming an even bigger nerd.

---

# References and Links

[^1]: [Christian Selig's Custom Keyboard Build](https://youtu.be/7UXsD7nSfDY?si=_hr36d2jh61xhEap)

[^2]: [Piantor Keyboard](https://shop.beekeeb.com/product/pre-soldered-piantor-split-keyboard/)

[^3]: [Miryoku Layout Github](https://github.com/manna-harbour/miryoku)

[^4]: [markstos Corne 42-key layout](https://mark.stosberg.com/markstos-corne-3x5-1-keyboard-layout/)

[^5]: [Precondition Blog: Home Row Mods](https://precondition.github.io/home-row-mods)
