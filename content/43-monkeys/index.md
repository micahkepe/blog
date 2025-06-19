+++
title = "Building a Godot Game! The Making of '43 Monkeys'"
date = 2024-11-26
updated = 2025-04-23
draft = false

[taxonomies]
categories = ["projects"]
tags = ["godot", "game-dev", "rice"]

[extra]
toc = true
+++

As part of my design course requirements at Rice University, I will be creating
a game in a [group of 4 (_and more!_)](#contributors) using the Godot engine
over the upcoming semester. This blog post will serve as a progress log for
the game's development and hopefully provide some good insights into the game
development process from someone who has never made a game before.

<!-- more -->

## Initial Project Proposal

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

The game is a keyboard-controlled top down 2D roguelike where the player
controls both the main monkey and the troop that can follow the player or move
independently. Through 5 different levels/floors, the player must solve puzzles,
defeat enemies, and avoid traps to escape the facility. The player can also
collect power ups and new monkeys to add to their troop. Begin a rogue-like, the
game will have perma-death, but the player can unlock shortcuts and new
abilities to make future runs easier.

{{ responsive(
    src="./images/teaser1.png"
    alt="A teaser image of gameplay from the final game"
    width=80
    caption="A snapshot of gameplay from the finished second level of the game."
)}}

---

## Progress Log

The following sections document the incremental progress we made over the
semester from a small MVP from winter break to the complete game at the end of
the spring semester.

### Pre-Class Work

Before the class officially starts, we are taking time to familiarize ourselves
with the Godot engine and the basics of game development. My first thoughts on
working with GDScript is that it like a blend of Python and TypeScript, which is
pretty cool. I'm excited to see how it works in practice. I've also been
watching some tutorials on the Godot engine and game development in general
to get a feel for the process.

As of now, we have basic character sprites and background tiles ready to go.
We are also working getting a basic scene set up in Godot to start testing
out movement and interactions. Godot's
[documentation](https://docs.godotengine.org/en/stable/index.html) is very
good and has been a great resource for getting started.

#### Overview of Godot

At the most basic level, creating games in Godot revolves around four major
concepts: (1) **scenes**, (2) **nodes**, (3) **the scene tree**, and (4)
**signals**. As the documentation says:

> "In Godot, a game is a tree of nodes that you group together into scenes.
> You can then wire these nodes so they can communicate using signals."

Every component of a Godot game is broken down into reusable assets called
**scenes**. Even though the name may make you think that a scene is a complete
level or screen, pretty much any element in your game can be its own scene,
whether it's a character, button, light source, etc. Godot will store these files
as `*.tscn` files containing information about resource dependencies, metadata,
and more. For example, here's the visual editor view of our game's eventual
`level_1.tscn` file:

{{ responsive(
    src="./images/level-1-view.png",
    alt="Level 1 scene in the Godot editor",
    caption="Level 1 scene in the Godot editor",
    width=80
) }}

This brings us to both the **scene tree** and **nodes**. On the left hand side
of the image above you can see the scene tree, which has all of the scenes
in the current scene. At the top is the scene root, in this case "Level1". Each
scene is composed of one or more nodes, which are the building blocks of every
scene. Godot defines a [`Node`](https://docs.godotengine.org/en/stable/classes/class_node.html)
base case from which all nodes inherit. All nodes have a name, editable
properties, callbacks to update every frame, can be extended with new properties
and values, and they can be added as a child to another node. **Together, nodes
form a tree**, and this is seen in the scene tree. Godot provides a massive
list of base node types that you can use and combine to create components
out of the box.

> **NOTE**: You might have noticed that nodes and scenes look the same in
> the editor. When you save a tree of nodes as a scene, it then shows as a single
> node, with its internal structure hidden in the editor.

Nodes and scene are scriptable and can be changed to function programmatically.
Godot has its own scripting language called GDScript that can be used; C++ is
another option as well.

The last major thing to mention is **signals**. Signals allow for nodes to alert
other nodes of an event. For example, in the main menu, we have a start button
that, when pressed, transitions from the start screen to the level 1 transition:

{{
responsive(
src="./images/start-btn-signal.png"
alt="Start button signal emissions",
width=60
)
}}

This can be handled in the `start_menu.gd` script programmatically:

```gd
## Handles the press event for the start button. Navigates to intro cutscene.
func _on_start_button_pressed() -> void:
	theme_player.stop()
	get_tree().change_scene_to_file("res://cutscenes/intro/intro_cutscene.tscn")
```

For a more complete breakdown of Godot, check out the documentation's
[Overview of Godot's key concepts](https://docs.godotengine.org/en/stable/getting_started/introduction/key_concepts_overview.html#doc-key-concepts-overview).

#### Handling Basic Movement

Now that we have a big picture idea of how Godot operates, let's break down how
we achieve something as seemingly simple as a navigating our character sprite
around the screen like this:

{{ gif(
sources=["videos/basic-movt.mp4"],
width=40,
caption="Hurray movement!"
)}}

First we have a **spritesheet** for our monkey. A spritesheet an image of
animation cells arranged into rows and columns that we use to make up the
individual frames of our animation:

{{
responsive(
src="./images/monkey-spritesheet.png"
alt="Base monkey spritesheet image"
caption="Subsection of the spritesheet for the main monkey character."
width=60
)
}}

We can create a new scene for the player and set the root node to be a
`CharacterBody2D`, which is "a 2D physics body specialized for characters
moved by script"-- perfect! We then can add an `AnimatedSprite2D` to add our
animations from our spritesheet, and a `CollisionShape2D` node so that the
character can collide with the world.

When we create a script for the scene, it will follow this format:

```gd
extends CharacterBody2D

## any signals, state variables, and onready references
## ...

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

## Called every frame.
## Handles input and updates the player's position and animation.
## @param delta: float - The elapsed time since the previous frame in seconds.
func _physics_process(_delta: float) -> void:
    pass

## any number of helper functions or utilities
## ...
```

Filling in more implementation, our final `player.gd` can be boiled down to
this:

```gd
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed: float = 300.0

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    # Handle movement input
    var input_velocity = Vector2.ZERO
    if Input.is_action_pressed("ui_right"):
        input_velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        input_velocity.x -= 1
    if Input.is_action_pressed("ui_up"):
        input_velocity.y -= 1
    if Input.is_action_pressed("ui_down"):
        input_velocity.y += 1

    # Normalize diagonal movement to prevent faster diagonal speed
    if input_velocity != Vector2.ZERO:
        input_velocity = input_velocity.normalized()

    # Set animation based on movement
    if input_velocity == Vector2.ZERO:
        _animated_sprite.play("idle")
    else:
        _animated_sprite.play("walk")
        # Flip sprite for left/right facing
        if input_velocity.x != 0:
            _animated_sprite.flip_h = input_velocity.x < 0

    # Apply movement
    velocity = input_velocity * speed
    move_and_slide()
```

This script handles WASD/arrow key input, normalizes diagonal movement,
updates animations, and moves the character with collision handling.

For a more detailed breakdown of how you can do this yourself, checking out
this [official Godot guide](https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html)
for animating 2D sprites.

#### Music

With a fun little open-source webapp called [BeepBox](https://www.beepbox.co/),
we were able to make some fun 8-bit music for our game.

{{ audio(
source="music/fonky-loop.ogg"
)}}

<br>

### Making an MVP Demo: Weeks 1-2

With the spring semester now in full swing and our team assembled, we are working
on getting our MVP (minimum viable product) ready for a demo scheduled at the end
of week 2 of the course.

Our big focus is looking at [flocking
algorithms](https://en.wikipedia.org/wiki/Flocking) and
[boids](https://en.wikipedia.org/wiki/Boids). **Boids** (bird-oid objects) were
developed by Craig Reynolds in 1986 to simulate coordinated animal motion
like bird flocks or fish schools. The algorithm is based on three simple
steering behaviors:

- Separation: Avoid crowding nearby flockmates
- Alignment: Steer towards the average heading of nearby flockmates
- Cohesion: Steer towards the average position of nearby flockmates

We become interested in this concept because one of the unique features of
our game is that the player will be able to control a group of monkeys that
will follow the player around the map or move independently as a swarm.

{{ gif(
sources=["videos/boids-demo.mp4"],
width = 80
)}}

The `boid.gd` script implements these behaviors for enemy or NPC characters,
with additional features like wall avoidance and attacking. Below are key
snippets capturing the essence of the flocking logic:

```gd
extends CharacterBody2D

@export var max_speed: float = 125.0
@export var max_force: float = 150.0
@export var view_radius: float = 300.0
@export var separation_distance: float = 35.0
@export var weight_separation: float = 15.0
@export var weight_alignment: float = 1.0
@export var weight_cohesion: float = 1.0
@export var weight_avoidance: float = 2.0
@export var raycast_length: float = 75.0
@onready var _anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
    if is_dead:
        return
    var steering = Vector2.ZERO
    var neighbors = _get_neighbors()

    # Apply flocking behaviors
    steering += _compute_separation(neighbors) * weight_separation
    steering += _compute_alignment(neighbors) * weight_alignment
    steering += _compute_cohesion(neighbors) * weight_cohesion
    steering += _compute_wall_avoidance() * weight_avoidance

    # Limit steering force
    if steering.length() > max_force:
        steering = steering.normalized() * max_force

    velocity += steering * delta
    if velocity.length() > max_speed:
        velocity = velocity.normalized() * max_speed
    move_and_slide()
    _update_animation()

func _get_neighbors() -> Array:
    var all_boids = get_tree().get_nodes_in_group("boids")
    var neighbors := []
    for b in all_boids:
        if b == self:
            continue
        var to_other = b.global_position - global_position
        if to_other.length() <= view_radius:
            neighbors.append(b)
    return neighbors

func _compute_separation(neighbors: Array) -> Vector2:
    if neighbors.is_empty():
        return Vector2.ZERO
    var steer = Vector2.ZERO
    for b in neighbors:
        var diff = global_position - b.global_position
        var dist = diff.length()
        if dist < separation_distance and dist > 0:
            steer += diff.normalized() / dist
    return steer.normalized() * max_force if steer.length() > 0 else Vector2.ZERO

func _compute_alignment(neighbors: Array) -> Vector2:
    if neighbors.is_empty():
        return Vector2.ZERO
    var avg_vel = Vector2.ZERO
    for b in neighbors:
        avg_vel += b.velocity
    avg_vel /= neighbors.size()
    var steer = (avg_vel - velocity).normalized() * max_force
    return steer

func _compute_cohesion(neighbors: Array) -> Vector2:
    if neighbors.is_empty():
        return Vector2.ZERO
    var avg_pos = Vector2.ZERO
    for b in neighbors:
        avg_pos += b.global_position
    avg_pos /= neighbors.size()
    var desired = (avg_pos - global_position).normalized() * max_speed
    var steer = (desired - velocity).normalized() * max_force
    return steer

func _compute_wall_avoidance() -> Vector2:
    var avoidance = Vector2.ZERO
    if $RayRight.is_colliding():
        avoidance += Vector2.LEFT
    if $RayLeft.is_colliding():
        avoidance += Vector2.RIGHT
    if $RayUp.is_colliding():
        avoidance += Vector2.DOWN
    if $RayDown.is_colliding():
        avoidance += Vector2.UP
    return avoidance.normalized() * max_force if avoidance.length() > 0 else Vector2.ZERO
```

**Update**: Demo MVP is completed. We ended up doing a simple demo level where
the player has to use their group of monkeys to deactivate lasers with
coordinated button presses and defeat a boss at the end. I'm pretty proud of
what we've been able to do some far in only a couple weeks of work, but we
also have a lot of work ahead of us as we figure out the rest of our levels,
polished up the art, etc.

#### Some more teasers

Little bit of the MVP demo in action:

{{ gif(
sources=["videos/mvp-demo.mp4"],
width = 80
)}}

Our pretty epic main theme (if I do say so myself):

{{ audio(
source="music/main-theme.ogg"
)}}

<br>

### Work Until Midterm Demo: Weeks 3-7

With the initial demo out of the way, we are now working on fleshing out the
rest of the game. This includes creating more levels, adding more mechanics,
and polishing up the art and music. While our art was pretty good for the MVP,
we really want to dial in the aesthetic of the game to be something truly
impressive. Part of this is diving deeper into writing custom shaders and
animations to make the game feel more alive.

Another big thing that we realized post-demo is that our initial conception of
the game having procedurally generated levels might lead to unintended
side effects. For example, troops could get stuck in walls or not be able to
complete a level's required puzzle. Because of this, we are going to lean into
more curated levels that we can test and refine.

#### Shaders

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

#### Added Animations

**_Stayed tuned._** I don't want to give away a lot but let's just say that
we've added some pretty cool animations to the game that make it feel much more
alive.

#### Boids: Revisited

We are making the boids much more interesting by adding targeting behavior to
them. Now, when the player is within their field of vision, they will target
the player and move towards them. This makes the game feel much more alive and
dynamic. The player can hide behind walls to temporarily escape the boids' line
sight, but the player has to now fend off the boids while trying to solve
puzzles.

```gd
## Returns the closest target node within the boid's view radius.
## @returns Node2D - The closest target node within the boid's view radius.
func _get_closest_target() -> Node2D:
	var closest_target = null
	var min_distance = INF
	for group in ["player", "troop"]:
		for target in get_tree().get_nodes_in_group(group):
			var distance = global_position.distance_to(target.global_position)
			var direction = (target.global_position - global_position).normalized()
			# temporary line of sight raycast for targeting
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(
				global_position,
				target.global_position,
				1
			)
			var result = space_state.intersect_ray(query)
			if distance < view_radius and not result:
				var angle_between = velocity.angle_to(direction)
				if abs(angle_between) <= deg_to_rad(view_angle_degrees / 2.0):
					if distance < min_distance:
						closest_target = target
						min_distance = distance
	return closest_target
```

#### 2025-02-18 Progress Video

{{ youtube(id="rKcuIBeEa2A", width=80) }}

<br>

### Midterm Demo

As of time of writing this (03/04/2025), we are less than a week away from our
midterm demo. We have been working on adding a lot of aesthetic features to the
levels with an expanded tileset and lots of new light elements which have
dramatically improved the look and feel of the game.

We're in the middle of polishing up the game for the upcoming demo and ironing
out lingering bugs and issues. For a little sneak peek, I'll let Zach's trailer
speak for itself:
[game trailer](https://www.youtube.com/watch?v=o46NNVcCdBM)

### Wrapping Up: Work Until Final Demo

Midterm demo went well! We are now focused on creating the finished MVP of the
game that we can showcase in our final presentation and demo. The major areas of
focus are:

- Finish complete gameplay
- Add more unique game elements and puzzles
- More unique monkey variants, both in terms of design and their unique
  abilities, attacks, etc.

We are hoping that by the end of the semester we will have a fully-fledged MVP
that can be embedded in a browser to allow people to play, so stay tuned!

---

## Play the Game on itch.io!

The game is now available for play on [itch.io](https://alpha-prime-studios.itch.io/43-monkeys)!
Play directly in your browser with the link below:

<div align="center">
    <iframe frameborder="0" src="https://itch.io/embed/3482305?dark=true" width="552" height="167"><a href="https://alpha-prime-studios.itch.io/43-monkeys">43 Monkeys by alpha prime studios | ⍺'</a></iframe>
</div>

---

## Contributors

### Core Developer Team

| Name              | Link(s)                                                                                                                         | Role           |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Zach Kepe         | [GitHub](https://github.com/zachkepe) [Website](https://www.zachkepe.com/) [LinkedIn](https://www.linkedin.com/in/zacharykepe/) | Core Developer |
| Grant Thompson    | [LinkedIn](https://www.linkedin.com/in/grantwthompson/)                                                                         | Core Developer |
| Kevin Lei         | [LinkedIn](https://www.linkedin.com/in/lei-kevin/)                                                                              | Core Developer |
| _Micah Kepe (me)_ | [GitHub](https://github.com/micahkepe) [Website](https://micahkepe.com/) [LinkedIn](https://www.linkedin.com/in/micah-kepe/)    | Core Developer |

### Outside Collaborators

| Name   | Link(s)                                                                                     | Role         |
| ------ | ------------------------------------------------------------------------------------------- | ------------ |
| Bospad | [Spotify](https://open.spotify.com/artist/6Z9DPgoBu600ZbUbdQqZQf?si=x_ITREWSQ_CKJkJmOaWXBQ) | Music Design |

<div align="center">
    <em>
        Interested in contributing? Check the <a href="https://github.com/micahkepe/43-monkeys">GitHub repository</a>
    </em>
</div>

<br>
