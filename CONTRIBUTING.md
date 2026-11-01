# Contributing

## Branching model

This package uses trunk-based development with release tags.

- `master` is always releasable. Nobody pushes to it directly; every change lands through a pull request.
- Work happens on short-lived branches created from `master`:

  | Prefix | Use for |
  |---|---|
  | `feat/<short-name>` | New feature |
  | `fix/<short-name>` | Bug fix |
  | `docs/<short-name>` | Documentation only |
  | `refactor/<short-name>` | Code change without behavior change |
  | `test/<short-name>` | Tests only |
  | `chore/<short-name>` | Tooling, CI, dependencies |
  | `release/<x.y.z>` | Version bump + CHANGELOG only |

- Pull requests are squash-merged into `master`, and the branch is deleted after merge.
- Every published version has a tag `vX.Y.Z` on `master`. The tag must match `version:` in `pubspec.yaml`.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add pinnedCountryCodes to CountryPhonePicker
fix: correct Iraq mobile prefixes
docs: document BottomSheetConfig
```

Mark breaking changes with `!` (`feat!: rename onSelect to onChanged`) and describe them in the PR.

## Before opening a pull request

```bash
flutter pub get
dart format lib test example/lib
flutter analyze
flutter test
```

Add an entry to `CHANGELOG.md` for user-facing changes. CI runs the same checks plus `flutter pub publish --dry-run` on every pull request.

## Versioning

[Semantic Versioning](https://semver.org/). While the package is `0.x`, a breaking change bumps the minor version (`0.1.5` to `0.2.0`) and everything else bumps the patch version.

## Releasing

1. Create `release/x.y.z` from an up-to-date `master`.
2. Bump `version:` in `pubspec.yaml` and add a `## x.y.z` section at the top of `CHANGELOG.md`.
3. Open a pull request, wait for CI, squash-merge.
4. Tag the merge commit and push the tag:

   ```bash
   git checkout master
   git pull
   git tag vx.y.z
   git push origin vx.y.z
   ```

5. The `Publish to pub.dev` workflow checks that the tag matches `pubspec.yaml`, runs the tests, and publishes.

Hotfixes follow the same path: `fix/<name>` pull request, then a `release/x.y.z` pull request and a tag.

## One-time maintainer setup

### pub.dev automated publishing

1. Open https://pub.dev/packages/country_phone_picker/admin.
2. Under **Automated publishing**, enable **Publishing from GitHub Actions**.
3. Repository: `adellahlouh/country_phone_picker`. Tag pattern: `v{{version}}`.
4. Optional: tick **Require GitHub Actions environment** and enter `pub.dev`. In GitHub, **Settings → Environments → pub.dev** you can then add required reviewers so each publish waits for approval.

### GitHub branch protection

**Settings → Branches → Add branch ruleset** (or classic rule) for `master`:

- Require a pull request before merging
- Require status checks to pass: `ci`
- Require branches to be up to date before merging
- Block force pushes and deletions

**Settings → General → Pull Requests**: allow squash merging only, and enable **Automatically delete head branches**.
