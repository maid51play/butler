# Butler

Butler is an open source tabling application by [5.1 Play][5-1-play] for use at in person events and in affiliated maid cafes. Butler primarily keeps track of which tables are open for seating and which maids are available to table. Because seating parties at a busy maid cafe is hectic, we strive to reduce human error by associating barcodes to tables so that Butler can handle assigning the maid to the correct table for us!

## Contributor Guidelines

5.1 Play strives to create an environment where our staff and streamers can teach each other real world skills that are applicable both inside and outside of our cafe. As an organization dedicated to the growth of our girls, we are proud to add "software development" to the list of many skills we offer to foster in our maids! While any and all contributions will be treasured, please keep in mind that we will prioritize supporting contributions from those involved with 5.1 Play and affiliated organizations to this end. For those of you who are not involved in running and organizing our cafe, we are working to include tickets labeled [ご主人様OK](labels/ご主人様OK) which are best suited for the level of collaboration accessible to you; we would love to see all of your smiling faces on our list of contributors!

Those affiliated with 5.1 Play who are interested in contributing to the codebase outside of the ご主人様OK label should contact **Midori** directly on discord. In addition to the content of this readme, she can provide the additional resources necessary to get started!

We are doing our best to clearly explain our contribution guidelines to avoid contributors doing unnecessary duplicate work or contributing to stale issues which are no longer being prioritized or are lacking appropriate levels of detail. Failure to follow the contribution guidelines below may result in your PR being closed, which would make all of us extremely sad! ｡ﾟ(*´□`)ﾟ｡ To avoid this, following the contribution guidelines closely and tagging @MeganeMidori before starting development work is best! ヾ(＾-＾)ノ

## Reporting a bug

If you find a bug in our codebase, we want to hear about it! Please [open up an issue](/issues/new/choose) about it with steps to reproduce the bug and the expected behavior vs the actual behavior. Screenshots are especially helpful! The maintainers of the codebase will label it as a [bug](/labels/bug) issue and prioritize it in the backlog appropriately. **Even if you intend to work on a fix yourself, please still open a bug ticket for posterity!** If you mention that you are already developing a fix for the bug, the maintainers will assign the issue to you and categorize it appropriately in the [project board](/projects/1).

## Requesting a feature

Although there is no guarantee that feature requests will be prioritized, we welcome any and all suggestions, especially from people who are actively using our software! To make a feature suggestion, please [open an issue](/issues/new/choose) about it! The maintaners of the codebase will label it as a [discussion](/labels/discussion) issue, and contributors can weigh in on the usefulness/plausibility of the suggested feature.

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

**The following advice has not been verified to work yet. If you try following these instructions and your app doesn't run, it is probably because the README is wrong ^^; Please [submit an issue](/issues/new/choose) so that we can update the README accordingly!**

1. In your terminal, generate a secret key base:

    ```$ mix phx.gen.secret```
1. Add the secret key base to your `.env` file:

    ```export SECRET_KEY_BASE="{secret key base goes here}"```
1. In your terminal, generate an auth secret:

    ```$ mix guardian.gen.secret``` 
1. Add the auth secret to your `.env` file:

    ```export AUTH_SECRET="{auth secret goes here}"```
1. To use your newly set environment variables, in your terminal run:

    ```$ source .env```

## Running the app

Once you have done the above steps, you can start your phoenix app by doing the following in your terminal:

1. Install dependencies:

    ```$ mix deps.get```
1. Create and migrate your database:

    ```$ mix ecto.create && mix ecto.migrate```
1. Populate the database with seed data:

    ```$ mix run priv/repo/seeds.exs```
1. Install Node.js dependencies:
    
    ```$ npm install```
1. Start Phoenix endpoint:

    ```$ mix phx.server```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You should be able to log in with the username `admin` and password `password`.

## FAQ

**Q:** Can I fork this app for use in other maid cafes?

**A:** Yes! Please do! If the feature you are adding isn't specific to your particular maid cafe and has the potential to be useful to other maid cafes that are using this app (like my own) please consider making a pull request so that we might all benefit from your contributions 🌸

**Q:** I'm involved in 5.1 Play or an affiliated maid cafe. Can I make contributions to the codebase?

**A:** Yes! We recommend talking to **Midori** directly on discord so she can give you access to the full extent of the resources available to staff, streamers, and volunteers.

**Q:** I don't know if my maid cafe is affiliated with 5.1 Play! Can I still contribute?

**A:** Talk to **Midori** on discord; she'll be able to tell you if you are affiliated with 5.1 Play and how to get involved.

**Q:** Did you really rename the `master` branch to `ご主人様`.

**A:** Yes and you literally can't stop me.

**Q:** It's really annoying to use a branch name that can't be typed out on an american keyboard 😭

**A:** in this house we suffer for fashion

**Q:** When I run the test I get an error that looks like `** (MatchError) no match of right hand side value: {:error, :secret_not_found}`

OR

When I try to run the server I get an error that looks like `** (ArgumentError) cookie store expects conn.secret_key_base to be set`

**A:** `$ source .env` and try again :3

## Resource Library 🌸
In this section you'll find helpful links for ramping up on the various technologies used in this project. If you have a blog article or tutorial that you think should be included in this list, please make a pull request or ask Midori to help you!

### Phoenix Resources
  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


[5-1-play]: <https://www.twitch.tv/51play>