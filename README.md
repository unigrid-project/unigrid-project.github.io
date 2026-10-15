# Unigrid documentation

Source of [unigrid-project.github.io](https://unigrid-project.github.io), the documentation site of the
Unigrid network, built with [Jekyll](https://jekyllrb.com) and [Just the Docs](https://just-the-docs.com).

- `index.md` is the home page.
- `docs/governance/` holds the DAO constitution, the proposals and their vote data.
- `docs/janus/` and `docs/hedgehog/` are copied from the [Janus](https://github.com/unigrid-project/janus-java/wiki)
  and [Hedgehog](https://github.com/unigrid-project/hedgehog/wiki) wikis at build time. Edit those pages in the wikis.

The [Pages workflow](.github/workflows/pages.yml) builds the site on every push and nightly, to pick up wiki
edits, and deploys `main`.

To build locally with Ruby 3.3:

```sh
git clone https://github.com/unigrid-project/hedgehog.wiki.git docs/hedgehog
git clone https://github.com/unigrid-project/janus-java.wiki.git docs/janus
bundle install
bundle exec jekyll serve
```
