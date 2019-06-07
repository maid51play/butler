# Butler

## FAQ

**Q:** Can I fork this app for use in other maid cafes?

**A:** Yes! Please do! If the feature you are adding isn't specific to your particular maid cafe and has the potential to be useful to other maid cafes that are using this app (like my own) please consider making a pull request so that we can all benefit from your contributions 🌸


**Q:** I'm involved in 5.1 Play or an affiliated maid cafe. Can I make contributions to the codebase?

**A:** Unfortunately in the aftermath of our last event this codebase has become incredibly messy again and as such isn't quite ready for contributors yet. That being said, allowing volunteers to pick up issues and make contributions is one of my major goals for the next year, so please keep an eye out for when we are open for contributors!

**Q:** I don't know if my maid cafe is affiliated with 5.1 Play! Can I still contribute?

**A:** Talk to **Midori** on discord; she'll be able to tell you if you are affiliated with 5.1 Play and how to get involved.

**Q:** Did you really rename the `master` branch to `ご主人様`.

**A:** Yes and you literally can't stop me.

**Q:** It's really annoying to use a branch name that can't be typed out on an american keyboard 😭

**A:** in this house we suffer for fashion

## Contributor Guidelines

5.1 Play strives to create an environment where our staff and streamers can teach each other real world skills that are applicable both inside and outside of our cafe. As an organization dedicated to the growth of our girls, we are proud to add "software development" to the list of many skills we offer to foster in our maids! While any and all contributions will be treasured, please keep in mind that we will prioritize supporting contributions from those involved with 5.1 Play and affiliated organizations to this end. For those of you who are not involved in running and organizing our cafe, we are working to include tickets labeled [ご主人様OK](/labels/ご主人様OK) which are best suited for the level of collaboration accessible to you; we would love to see all of your smiling faces on our list of contributors!

Those affiliated with 5.1 Play who are interested in contributing to the codebase outside of the ご主人様OK label should contact **Midori** directly on discord. In addition to the content of this readme, she can provide the additional resources necessary to get started!

## Cloning the repo

Unless you have been given collaborator status (you know who you are), you will need to fork the repo in order to make contributions. Please fork this repo as you would any other :3

## Picking up tickets

Before you start writing code, please make sure you have followed the following process!

1. Browse the [ご主人様OK](/labels/ご主人様OK) label for straight forward, bite-sized chunks of work, or browse the To-Do column in our [Project Board](/projects/1) and find an open issue that appeals to you.
1. Comment on the issue you're picking up so that others know that the issue is in progress. Make sure to tag @MeganeMidori so that she can update the project board and assign the issue to you.
1. In bash make sure the ご主人様 branch is up to date:
    ```
    $ git checkout ご主人様
    $ git pull origin ご主人様
    ```
1. checkout a new branch from the `ご主人様` branch:
    ```
    $ git checkout -b feature/branch-name-here-573
    ```
    make sure you follow the naming convention: [feature | chore | bug]/descriptive-branch-name-{issueId}
1. While development progresses, please make sure you keep an eye on the discussion in your issue so that you don't miss valuable feedback from contributors who might be able to help with the task you're working on, especially if it's a long running ticket! Do post questions that might come up as well; if you tag @MeganeMidori she will be happy to address them personally!
1. When your feature is ready for review, please check for any linter errors or failing tests before creating your pull request. When writing your PR, make sure to include either "resolves #`{issueId}`" or "addresses #`{issueId}`" depending on whether the original issue is ready to be closed or not after merging your PR. Also make sure your PR includes sufficient background/information to make it easy peasy to review~
1. Merging into the `ご主人様` branch will require at least one passing review from an admin.
1. After your PR has been accepted, please go ahead and merge using the "Squash and merge" button on your PR. Thank you so much for your contribution!

## Secrets: それは…ひ•み•ちゅ(｡•ᴗ-)~☆

![](https://media.giphy.com/media/5fBH6zl91iH9rzPc556/giphy.gif)

Running the app will require you to create a `.env` file to store certain app secrets! Trying to run the app without them is a big non-non~

## Running the app

Once you have done the above steps, start your phoenix app by doing the following:

1. Install dependencies with `mix deps.get`
1. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
1. Populate the database with seed data with `mix run priv/repo/seeds.exs`
1. Install Node.js dependencies with `npm install`
1. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
