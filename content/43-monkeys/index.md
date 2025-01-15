+++
title = "Building a Godot Game! The Making of '43 Monkeys'"
date = 2024-11-26
draft = false

[taxonomies]
categories = ["projects"]
tags = ["godot", "game-dev", "rice"]

[extra]
toc = true
+++

As part of my design course requirements at Rice University, I will be creating
a game in a group of 4 using the Godot engine over the upcoming semester. This
blog post will serve as a progress log for the game's development and hopefully
provide some good insights into the game development process from someone who
has never made a game before.

<!-- more -->

# Initial Project Proposal

Not to give too much away yet, but our game is called **43 Monkeys** and draws
a lot of inspiration from this news source:
[What we know after 43 monkeys escaped a South Carolina research facility](https://www.cbsnews.com/news/south-carolina-escaped-monkeys-what-we-know/)

<br>

{{ responsive(src="images/game-teaser.png",
alt="A teaser image of our game idea from our initial project proposal.",
caption="A teaser image of our game idea from our initial project proposal.",
width=80) }}

A lot is still up in the air (open-source or not, full storyboard, etc.), but
I'm excited to see where this project goes. I'll be updating this post as we
make progress, so stay tuned!

---

# Progress Log

<details>
<summary>Pre-Class Work</summary>

**Updates**

Before the class officially starts, we are taking time to familiarize ourselves
with the Godot engine and the basics of game development. My first thoughts on
working with GDScript is that it like a blend of Python and TypeScript, which is
pretty cool. I'm excited to see how it works in practice. I've also been watching
some tutorials on the Godot engine and game development in general to get a feel
for the process.

As of now, we have basic character sprites and background tiles ready to go. We
are also working getting a basic scene set up in Godot to start testing out
movement and interactions. Godot's [documentation](https://docs.godotengine.org/en/stable/index.html)
is very good and has been a great resource for getting started.

**Basic Movement**

{{ gif(
    sources=["videos/basic-movt.mp4"],
    width=40
)}}

**Helpful Tutorials**

{{ youtube(id="LOhfqjmasi0", width=90)}}

**Music**

With a fun little open-source webapp called [BeepBox](https://www.beepbox.co/),
we were able to make some fun 8-bit music for our game.

</details>

<details>
<summary>Making an MVP Demo: Weeks 1-2</summary>

With the spring semester now in full swing and our team assembled, we are working
on getting our MVP (minimum viable product) ready for a demo scheduled at the end
of week 2 of the course.

Our big focus is looking at [flocking algorithms](https://en.wikipedia.org/wiki/Flocking)
and [boids](https://en.wikipedia.org/wiki/Boids). This is because one of the
unique features of our game is that the player will be able to control a group
of monkeys that will follow the player around the map or move independently
as a swarm.

{{ gif(
    sources=["videos/boids-demo.mp4"],
    width = 80
)}}

</details>

{{ utterances() }}
