<div align="center">

  <a href="https://www.youtube.com/@nerdware-io">
    <img src="https://github.com/Nerdware-LLC/.github/blob/main/profile/nerdware_logo.png" height="120" alt="Nerdware logo" />
  </a>

  <h1>Nerdware Template NPM Package Repo</h1>

**🚀 An Awesome Template to Jumpstart Projects 🚀**

[![pre-commit][pre-commit-badge]](https://pre-commit.com "pre-commit.com")
[![semantic-release][semantic-badge]](https://github.com/semantic-release/semantic-release "github.com: semantic-release")
[![License: MIT][license-badge]](/LICENSE "View License")

<!--   BADGE LINKS   -->

[pre-commit-badge]: https://img.shields.io/badge/pre--commit-F8B424.svg?logo=pre-commit&logoColor=F8B424&labelColor=gray
[semantic-badge]: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-E10079.svg
[license-badge]: https://img.shields.io/badge/License-MIT-000080.svg

</div>

<!--
   TODO Remove the below README section upon completion of post-init setup.
   TODO Update links in the CONTRIBUTING.md file.
-->

### **_Repo Setup_**

1. Update `package.json` fields:

   - `name`
   - `description`
   - `author`
   - `repository.url`
   - `homepage`
   - `bugs.url`
   - `keywords`

2. Install dev dependencies — here's the command with recommended packages:

   ```bash
   npm i -D \
      @serverless-guru/prettier-plugin-import-order \
      @types/node \
      @typescript-eslint/eslint-plugin \
      @typescript-eslint/parser \
      @vitest/coverage-v8 \
      eslint \
      eslint-config-prettier \
      eslint-import-resolver-typescript \
      eslint-plugin-import \
      eslint-plugin-node \
      eslint-plugin-vitest \
      prettier \
      type-fest \
      typescript \
      vitest \
      vitest-github-actions-reporter
   ```

3. Set up [**pre-commit**](https://pre-commit.com/#install):

   1. Ensure it's [installed](https://pre-commit.com/#install) locally or in an executable image.
   2. Update the [**pre-commit config file**](/.pre-commit-config.yaml) with project-appropriate hooks and tools. The pre-commit project provides a complete list of [supported hooks here](https://pre-commit.com/hooks.html). Some popular hook sources:
      - ["Out-of-the-Box" pre-commit Hooks](https://github.com/pre-commit/pre-commit-hooks)
      - [pre-commit Hooks from gruntwork.io](https://github.com/gruntwork-io/pre-commit)
      - [Some Terraform-specific pre-commit Hooks](https://github.com/antonbabenko/pre-commit-terraform)
   3. Run `pre-commit install` to ensure local .git hooks are present.

4. Complete the setup of the [`Test Workflow`](./.github/workflows/test.yaml) GitHub Action:

   1. To enable [CodeCov](https://app.codecov.io/gh) updates, head to CodeCov and obtain a token for the repo. Then add the token as a [GitHub Actions Secret][gh-action-docs-url] named `CODECOV_TOKEN`.

5. If the repo will include [branch protection rules][gh-branch-protect-url], take the additional steps needed to enable the [**Semantic-Release GitHub Action**][release-gh-action-url]:

   1. [Create a GitHub Personal Access Token][gh-pat-docs-url]. When creating the token, the minimum required scopes are:
      - `repo` for a private repository
      - `public_repo` for a public repository
   2. Add a [GitHub Actions Secret][gh-action-docs-url] to your repo named `SEMANTIC_RELEASE_TOKEN` with the value set to the new PAT you created in the previous step.
   3. Once the secret has been added to your repo, update the [release.yaml workflow](/.github/workflows/release.yaml):
      - Update **on.push.paths** path glob "\*\*" to reflect only the project files that should trigger the Release workflow (e.g., "\*.js" or "\*.tf").
      - Delete the "**check-required-secret**" job (it was included so you can push initialization commits without triggering a bunch of failed GH Action runs).

   > Optionally, if you'd like to auto-assign GH Issues on release failures, you can add **assignees** to the "@semantic-release/github" plugin in [.releaserc.yaml](/.releaserc.yaml).

   [gh-branch-protect-url]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
   [release-gh-action-url]: https://github.com/Nerdware-LLC/reusable-action-workflows#semantic-release
   [gh-pat-docs-url]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
   [gh-action-docs-url]: https://docs.github.com/en/actions/security-guides/encrypted-secrets

6. Remove this section from the README.

7. Profit 💰💰💰🥳🎉 <!-- https://knowyourmeme.com/memes/profit -->

## 🚀 Getting Started

<!-- TODO Add usage info to README -->

🚧 This README is a work in progress. Please check back soon for more information. 🚧

## 🤝 Contributing

<!--
  TODO Update below links for GH-Issues and GH-PRs:

  [repo-pulls]: https://github.com/<REPO_OWNER>/<REPO_NAME>/pulls
  [repo-issues]: https://github.com/<REPO_OWNER>/<REPO_NAME>/issues
-->

[repo-pulls]: https://github.com//pulls
[repo-issues]: https://github.com//issues

Pull requests are welcome! Before you begin, please check existing [GitHub Issues][repo-issues] and [Pull Requests][repo-pulls] to see if your idea is already in the pipeline. If not, [here's a guide on how to contribute to this project](./CONTRIBUTING.md). Thank you!

## 📝 License

All files, scripts, and source code contained herein are open-source software licensed under an [MIT License](/LICENSE).

See [LICENSE](/LICENSE) for more information.

<div align="center" style="margin-top:35px;">

## 💬 Contact

Trevor Anderson — [Trevor@Nerdware.cloud](mailto:trevor@nerdware.cloud) — [@TeeRevTweets](https://twitter.com/teerevtweets)

[<img src="https://github.com/trevor-anderson/trevor-anderson/blob/main/assets/YouTube_icon_circle.svg" height="40" alt="Check out Nerdware on YouTube" />](https://www.youtube.com/@nerdware-io)
&emsp;
[<img src="https://github.com/trevor-anderson/trevor-anderson/blob/main/assets/LinkedIn_icon_circle.svg" height="40" alt="Trevor Anderson's LinkedIn" />](https://www.linkedin.com/in/meet-trevor-anderson/)
&emsp;
[<img src="https://github.com/trevor-anderson/trevor-anderson/blob/main/assets/Twitter_icon_circle.svg" height="40" alt="Trevor Anderson's Twitter" />](https://twitter.com/TeeRevTweets)
&emsp;
[<img src="https://github.com/trevor-anderson/trevor-anderson/blob/main/assets/email_icon_circle.svg" height="40" alt="Email Trevor Anderson" />](mailto:trevor@nerdware.cloud)

[**_Dare Mighty Things._**](https://www.youtube.com/watch?v=GO5FwsblpT8)

</div>
