# CLAUDE.md

Flutter package `country_phone_picker`, published on pub.dev. Branching and release rules live in `CONTRIBUTING.md`.

## Git workflow (follow automatically for every change, no need to ask)

1. Never commit on `master`. Before the first edit of a change:
   `git checkout master && git pull --ff-only && git checkout -b <type>/<short-name>`
   Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `release`.
2. Before committing run:
   `dart format lib test example/lib && flutter analyze && flutter test`
3. Add a `CHANGELOG.md` entry for user-facing changes (match existing bullet style). Do not bump `version:` outside a `release/x.y.z` branch.
4. Commit with a Conventional Commit message, push the branch, and open a PR to `master` with `gh pr create` filling `.github/PULL_REQUEST_TEMPLATE.md`. These steps need no confirmation.

Never, unless the user explicitly asks in that conversation:
- push to `master` or force-push any branch
- merge a PR
- create or push a `v*` tag (pushing a tag publishes to pub.dev and cannot be undone)

Release request: open a `release/x.y.z` PR (version bump + CHANGELOG). Tag only after the user confirms it is merged and says to tag.
