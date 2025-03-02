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
a game in a [group of 4 (_and more!_)](#contributors) using the Godot engine over the
upcoming semester. This blog post will serve as a progress log for the game's
development and hopefully provide some good insights into the game
development process from someone who has never made a game before.

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

## Game Description

In **43 Monkeys**, the player controls a group of monkeys that have escaped from
a research facility. The monkeys must navigate through a series of puzzles and
obstacles to escape the facility and make it to freedom on the outside. Along
the way they can save more monkeys to add to their troop and use their unique
abilities to solve puzzles and defeat enemies.

## Game Mechanics

The game is a keyboard-controlled top down 2d rogue-like where the player controls
both the main monkey and the troop that can follow the player or move
independently. Through 5 different levels/floors, the player must solve puzzles,
defeat enemies, and avoid traps to escape the facility. The player can also
collect power ups and new monkeys to add to their troop. Begin a rogue-like, the
game will have perma-death, but the player can unlock shortcuts and new abilities
to make future runs easier.

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

As of now, we have basic character sprites and background tiles ready to go.
We are also working getting a basic scene set up in Godot to start testing
out movement and interactions. Godot's
[documentation](https://docs.godotengine.org/en/stable/index.html) is very
good and has been a great resource for getting started.

**Basic Movement**

{{ gif(
sources=["videos/basic-movt.mp4"],
width=40
)}}

**Music**

With a fun little open-source webapp called [BeepBox](https://www.beepbox.co/),
we were able to make some fun 8-bit music for our game.

{{ audio(
source="music/fonky-loop.ogg"
)}}

</details>

<details>
    <summary>Making an MVP Demo: Weeks 1-2</summary>

With the spring semester now in full swing and our team assembled, we are working
on getting our MVP (minimum viable product) ready for a demo scheduled at the end
of week 2 of the course.

Our big focus is looking at [flocking
algorithms](https://en.wikipedia.org/wiki/Flocking) and
[boids](https://en.wikipedia.org/wiki/Boids). This is because one of the
unique features of our game is that the player will be able to control a
group of monkeys that will follow the player around the map or move
independently as a swarm.

{{ gif(
sources=["videos/boids-demo.mp4"],
width = 80
)}}

**Update**: Demo MVP is completed. We ended up doing a simple demo level where
the player has to use their group of monkeys to deactivate lasers with
coordinated button presses and defeat a boss at the end. I'm pretty proud of
what we've been able to do some far in only a couple weeks of work, but we
also have a lot of work ahead of us as we figure out the rest of our levels,
polished up the art, etc.

**Some more teasers**

Little bit of the MVP demo in action:

{{ gif(
sources=["videos/mvp-demo.mp4"],
width = 80
)}}

Our pretty epic main theme (if I do say so myself):

{{ audio(
source="music/main-theme.ogg"
)}}

</details>

<details open>
    <summary>Work Until Midterm Demo: Weeks 3-7</summary>

With the initial demo out of the way, we are now working on fleshing out the
rest of the game. This includes creating more levels, adding more mechanics,
and polishing up the art and music. While our art was pretty good for the MVP,
we really want to dial in the aesthetic of the game to be something truly
impressive. Part of this is diving deeper into writing custom shaders and
animations to make the game feel more alive.

Another big thing that we realized post-demo is that our initial conception of
the game having procedurally generated levels might lead to unintended
side effects like the troops getting stuck in walls or not being able to
complete a level's required puzzle, so we are going to lean into more
curated levels that we can test and refine.

**Shaders**

Shaders have been another interesting challenge. The largest conceptual change
is that the shader coding paradigm is much different than a traditional piece
of code. Instead of writing a function that takes in some inputs and returns
some outputs, you are writing a function that takes in some inputs and modifies
**every pixel** individually. This is a very different way of thinking about
code and has been a fun challenge to wrap my head around. With just a little
bit of work, we were able to create a simple VHS monitor-style shader that
adds a cool wave effect to the screen when we are doing exposition cutscenes.

For a fantastic introduction to the world of shaders, I highly recommend
checking out [The Book of Shaders](https://thebookofshaders.com/).
Additionally, for Godot-specific shader help, the [Godot
Shaders](https://godotshaders.com/) website has been a great resource for
building off the work of others.

**Added Animations**

**_Stayed tuned._** I don't want to give away a lot but let's just say that
we've added some pretty cool animations to the game that make it feel much more
alive.

**Boids: Revisited**

We are making the boids much more interesting by adding targeting behavior to
them. Now, when the player is within their field of vision, they will target
the player and move towards them. This makes the game feel much more alive and
dynamic. The player can hide behind walls to temporarily escape the boids' line
sight, but the player has to now fend off the boids while trying to solve
puzzles.

**2025-02-18 Progress Video**

{{ youtube(id="rKcuIBeEa2A", width=80) }}

</details>

---

# Contributors

## Core Developer Team

| Name              | Link(s)                                                                                                                         | Role           |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Zach Kepe         | [GitHub](https://github.com/zachkepe) [Website](https://www.zachkepe.com/) [LinkedIn](https://www.linkedin.com/in/zacharykepe/) | Core Developer |
| Grant Thompson    | [LinkedIn](https://www.linkedin.com/in/grantwthompson/)                                                                         | Core Developer |
| Kevin Lei         | [LinkedIn](https://www.linkedin.com/in/lei-kevin/)                                                                              | Core Developer |
| _Micah Kepe (me)_ | [GitHub](https://github.com/micahkepe) [Website](https://micahkepe.com/) [LinkedIn](https://www.linkedin.com/in/micah-kepe/)    | Core Developer |

## Outside Collaborators

| Name   | Link(s)                                                                                     | Role         |
| ------ | ------------------------------------------------------------------------------------------- | ------------ |
| Bospad | [Spotify](https://open.spotify.com/artist/6Z9DPgoBu600ZbUbdQqZQf?si=x_ITREWSQ_CKJkJmOaWXBQ) | Music Design |
