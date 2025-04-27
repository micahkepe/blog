+++
title = "vimtutor-sequel: The Extended vimtutor"
date = 2024-08-04
draft = false

[taxonomies]
categories = ["projects"]
tags = ["vim", "software package"]
+++

The vimtutor program is the essential starting point for anyone looking to learn
the basics of using Vim. In as little as a half hour, you can learn 90% of what
you'll ever need for vim, however, there are many useful motions and commands
that are left out of the program. This article details the simple software
package I wrote to address this limitation, `vimtutor-sequel`.

<!-- more -->

## The Journey

I initially created `vimtutor-sequel` to fill in the gaps left by the original
vimtutor. After completing the original tutorial, I felt there were many
advanced features that users could benefit from, which were not covered. Thus,
`vimtutor-sequel` was born.

{{
    responsive(src="teaser.png",
    alt="Screen shot of the vimtutor-sequel v1.0 program on launch.",
    width=80)
}}

## Featured Lessons (as of 2024-08-04)

The original vimtutor has 7 lessons, I created 8 additional lessons for
`vimtutor-sequel`. Here is a list of the lessons:

{{ note(
header="Lesson Included"
body="

- Lesson 8: Splitting Screens
- Lesson 9: Spellcheck
- Lesson 10: Indenting, Commenting, and Changing Case
- Lesson 11: Advanced Search and Replace
- Lesson 12: Macros
- Lesson 13: Vim Scripting
- Lesson 14: Vim Plugins
- Lesson 15: Vim Sessions and Registers
  ")}}

## Unexpected Popularity

To promote the project, I wrote posts on Reddit and HackerNews, detailing the
features and the motivation behind creating `vimtutor-sequel`. The response was
overwhelming.

I woke up the next day to find that the repository had gained 80 stars
overnight. The popularity continued to surge, and within just two days, the
project had amassed over 250 stars. It was an incredible and unexpected response.

At the time of writing, `vimtutor-sequel` has over 250 stars and has gained
significant traction, especially on HackerNews where it reached the front page
and garnered over 200 points. The project also saw a lot of engagement on
Reddit, particularly in the [r/vim](https://www.reddit.com/r/vim/) community.

## Community Feedback

The feedback has been tremendous. I've received valuable input from the issues
tab on GitHub, as well as from Reddit responses and HackerNews comments. This
feedback has been instrumental in planning further improvements to the project.

{{
    responsive(src="traffic.png",
    alt="GitHub Traffic for vimtutor-sequel",
    caption=
    "Above: Snapshot of GitHub traffic for vimtutor-sequel showing the top
    source of traffic from HackerNews with 2,834 views.",
    width=60)
}}

## Future Plans

With the initial success and the community's interest, I plan to continue
enhancing `vimtutor-sequel`. Here are a few things on the roadmap:

- Adding more advanced lessons and topics.
- Improving the existing content based on user feedback.
- Exploring ways to make the tutorial even more interactive and engaging.

### How You Can Help

If you haven’t tried `vimtutor-sequel` yet, I encourage you to give it a go and
see how it can take your Vim skills to the next level. Your feedback is
incredibly valuable, and I would love to hear your thoughts on how to make it
even better.

1. **Try It Out**: [Download
   `vimtutor-sequel`](https://github.com/micahkepe/vimtutor-sequel) and start
   the lessons.
2. **Provide Feedback**: Use the [Issues
   tab](https://github.com/micahkepe/vimtutor-sequel/issues) on GitHub to
   report bugs, suggest new features, or share your experience.
3. **Contribute**: If you're a developer, feel free to fork the repository
   and submit pull requests. Contributions are always welcome!
4. **Star the Repository**: If you find `vimtutor-sequel` useful, consider
   starring the repository on GitHub to help others find it.
5. **Share the Project**: Spread the word about `vimtutor-sequel` on social
   media, forums, or with your friends and colleagues who use Vim.

Thank you for reading, and happy Vimming!

**Update 1**: The project has grown to 475+ stars and continues to receive
contributions and feedback from the community! Additionally, a new lesson on
change navigation has been added to the tutorial as Lesson 16.

**Update 2**: `vimtutor-sequel` is now in Homebrew! You can install it on macOS
using `brew install vimtutor-sequel`.

**Links:**

- [GitHub Repository](https://github.com/micahkepe/vimtutor-sequel)
- [Issues & Feedback](https://github.com/micahkepe/vimtutor-sequel/issues)
- [Reddit Post](https://www.reddit.com/r/vim/comments/1eipuan/i_made_an_extended_version_of_vimtutor/)
- [HackerNews Post](https://news.ycombinator.com/item?id=41144843)
