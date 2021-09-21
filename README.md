[![CircleCI](https://circleci.com/gh/maid51play/butler.svg?style=svg)](https://circleci.com/gh/maid51play/butler)

# Butler

Butler is an open source tabling application by [5.1 Play][5-1-play] for use at in person events and in affiliated maid cafes. Butler primarily keeps track of which tables are open for seating and which maids are available to table. Because seating parties at a busy maid cafe is hectic, we strive to reduce human error by associating barcodes to tables so that Butler can handle assigning the maid to the correct table for us!

## Contributor Guidelines

We are doing our best to clearly explain our contribution guidelines to avoid contributors doing unnecessary work. Failure to follow the [contribution guidelines][contributor-workflow] may result in your PR being closed, which would make all of us extremely sad! ｡ﾟ(*´□`)ﾟ｡ To avoid this, following the [contribution guidelines][contributor-workflow] closely and tagging @MeganeMidori before starting development work is best! ヾ(＾-＾)ノ

## Reporting a bug

If you find a bug in our codebase, we want to hear about it! Please [open up an issue][new-issue] about it with steps to reproduce the bug. Screenshots are especially helpful! The issue will be labeled as a [bug][label-bug] and a maintainer will prioritize it in the backlog appropriately. **Even if you intend to work on a fix yourself, please still open a bug ticket for posterity!** If you mention that you are already developing a fix for the bug, the maintainers will assign the issue to you and categorize it appropriately in the [project board][project-board].

## Requesting a feature

Although there is no guarantee that feature requests will be prioritized, we welcome any and all suggestions, especially from people who are actively using our software! To make a feature suggestion, please [open an issue][new-issue] about it! It will be labeled as a [discussion][label-discussion] issue, and contributors can weigh in on the usefulness/plausibility of the suggested feature.

## Cloning the repo

Unless you have been given collaborator status (you know who you are), you will need to fork the repo in order to make contributions. Please fork this repo as you would any other :3

## Picking up tickets

Before you start writing code, please make sure you have followed the process outlined in our [contributor workflow wiki page][contributor-workflow]!

## System dependencies

To prepare your development environment you will need to install the following:

1. [Elixir](https://elixir-lang.org/install.html)
1. [PostgreSQL](https://www.postgresql.org/)

## Secrets: それは…ひ•み•ちゅ(｡•ᴗ-)~☆

![](https://media.giphy.com/media/5fBH6zl91iH9rzPc556/giphy.gif)

Running the app will require you to create a `.env` file to store certain app secrets! Trying to run the app without them is a big non-non~

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

## Running tests

### Unit tests
1. `$ npm test` runs the front end component tests in Jest
1. `$ source .env && mix test` runs the elixir tests

### Cypress end to end tests
1. `$ MIX_ENV=cypress mix do ecto.drop, ecto.create, ecto.migrate`
1. `$ MIX_ENV=cypress mix phx.server`
1. In another window, `$ npm run cypress:open`
1. The cypress window should open. From here you can run any test in the test suite!

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

## Butler App Architecture

Our app architecture is documented in [our wiki][architecture-wiki]. Please check it out to get a more in depth technical introduction to this codebase!

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


[5-1-play]: <https://www.twitch.tv/51play>
[label-ご主人様-ok]: <https://github.com/MeganeMidori/butler/labels/%E3%81%94%E4%B8%BB%E4%BA%BA%E6%A7%98OK>
[label-bug]: <https://github.com/MeganeMidori/butler/labels/bug>
[label-discussion]: <https://github.com/MeganeMidori/butler/labels/discussion>
[new-issue]: <https://github.com/MeganeMidori/butler/issues/new/choose>
[project-board]: <https://github.com/MeganeMidori/butler/projects/1>
[contributor-workflow]: <https://github.com/MeganeMidori/butler/wiki/Contributor-Workflow-(AKA-how-to-pick-up-tickets)>
[architecture-wiki]: <https://github.com/MeganeMidori/butler/wiki/Butler-App-Architecture>
