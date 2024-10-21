# ska-tango-tangogql-ariadne-pipeline

# TangoGQL implemented in Ariadne

Uses Ariadne (https://ariadnegraphql.org) to create a Tango GraphQL API compatible with TangoGQL.

## Motivation

Basically all the dependencies of tangogql are getting really old, and upgrading them is likely to take a lot of work. We've run into issues with python 3.10, making this fairly urgent. The situation with graphene 2/3 and websockets is still confusing.

The old tangogql code base is messy, and a bit overcomplicated in places.

Also, there are various "pitfalls" in the current implementation where seemingly innocent queries can cause huge amounts of traffic against the control system and take an unreasonably long time. There are some ways I think we can mitigate this, but it would need significant refactoring. Starting from scratch we can consider this "properly".

Ariadne is relatively new, though it's been around for a few years, and based on the same fundamental lib as graphene 3 (graphql-core). It takes a different approach where it starts with the GraphQL schema in raw text format, and then you implement types and resolvers for it in python. The schema file in the repo was exported directly from tangogql so it should be correct.

So far Ariadne seems very nice to use, there is almost no "boilerplate" and the code is pretty easy to read, as long as you refer back to the schema (`tangogql.graphql`).

## Notes

I've tried to keep the resolvers efficient, so that e.g. we re-use proxies, read attributes in batches instead of one by one, etc. Also wraps non-async parts of the Tango API in executors so that hopefully nothing is blocking. The drawback is that this makes things a little harder to understand as there are implicit dependencies.

The "dataloader" concept helps with this, but it's also kind of "magic". See `loaders.py`.

There is probably some better way to structure the code to make it more readable.

## Configuration

The server can be configured either using environment variables, or an `.env` file.
See `settings.py` for the available settings. For a production setting, you should
at least set the `TANGOGQL_SECRET` to something random, it's used for encrypting client auth
data.

For local testing, you can set `NO_AUTH=true` to disable all the auth stuff.

You can override logging config by pointing `logging_config` to a different
file than the default `logging.ini`.
