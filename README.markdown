![Sourcemeta JSON Schema Standard Library](./banner.png)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17526561.svg)](https://doi.org/10.5281/zenodo.17526561)

***
**Browse the schemas at [https://schemas.sourcemeta.com/sourcemeta/std](https://schemas.sourcemeta.com/sourcemeta/std)**
***

Building professional OpenAPI specifications demands precision, but mastering
JSON Schema is hard. This library eliminates that burden by providing
production-ready schemas that encode industry standards and best practices.
*Reference them directly in your API specifications and focus on what matters:
designing great APIs.*

> Led and maintained by a member of the JSON Schema Technical Steering Committee

**Use this library to:**

- Build production-grade OpenAPI specifications without writing schemas from scratch
- Skip the JSON Schema learning curve while maintaining expert-level quality
- Meet compliance and regulatory requirements with standards-based validation
- Establish a solid foundation for your organisation's API governance program

> [!WARNING]
> This project is in its early stages with much more to come. We need your
> feedback to shape its future. Please [share your thoughts and
> suggestions](https://github.com/sourcemeta/std/issues) on what you would like
> to see.

> [!NOTE]
> All schemas target JSON Schema 2020-12, the dialect used by OpenAPI v3.1 and
> later. Earlier JSON Schema dialects will be supported in the future.

## :bookmark_tabs: Table of Contents

- [:rocket: Getting Started](#rocket-getting-started)
    - [From Sourcemeta Schemas](#from-sourcemeta-schemas)
    - [From GitHub Releases](#from-github-releases)
    - [Using Git Submodules](#using-git-submodules)
    - [Using Vendorpull](#using-vendorpull)
- [:mortar_board: Citing](#mortar_board-citing)
- [:page_facing_up: License](#page_facing_up-license)
- [:handshake: Contributing](#handshake-contributing)
- [:email: Contact](#email-contact)

## :rocket: Getting Started

While you can always copy-paste schemas directly, here are more convenient and
maintainable ways to consume them.

### From Sourcemeta Schemas

We periodically publish the JSON Schema standard library to [Sourcemeta
Schemas](https://schemas.sourcemeta.com/sourcemeta/std), our free service for
hosting open-source schemas. Each schema gets a unique HTTPS URL that you can
directly reference from your OpenAPI specifications using the
[`$ref`](https://www.learnjsonschema.com/2020-12/core/ref) keyword. For
example:

```yaml
schema:
  type: object
  properties:
    email:
      $ref: 'https://schemas.sourcemeta.com/sourcemeta/std/<version>/ietf/email/address'
```

To de-reference and embed these external URLs when distributing your OpenAPI
specification, use standard tools like [`redocly
bundle`](https://redocly.com/docs/cli/commands/bundle).

### From GitHub Releases

We publish archives of the JSON Schema standard library to [GitHub
Releases](https://github.com/sourcemeta/std/releases). Download and extract an
archive to your preferred location, then reference the JSON files from your
OpenAPI specifications using the
[`$ref`](https://www.learnjsonschema.com/2020-12/core/ref) keyword with a
relative path. For example:

```yaml
schema:
  type: object
  properties:
    email:
      $ref: "../path/to/sourcemeta-std/ietf/email/address.json"
```

### Using Git Submodules

If your OpenAPI specification lives in a Git repository, you can add this
library as a [git
submodule](https://git-scm.com/docs/git-submodule). This approach keeps the
schemas versioned alongside your code and ensures consistent access across your
team. Add the submodule to your repository:

```sh
git submodule add https://github.com/sourcemeta/std std
```

Then reference the schemas using the
[`$ref`](https://www.learnjsonschema.com/2020-12/core/ref) keyword with a
relative path. For example:

```yaml
schema:
  type: object
  properties:
    email:
      $ref: './std/schemas/ietf/email/address.json'
```

### Using Vendorpull

[Vendorpull](https://github.com/sourcemeta/vendorpull) is our tool for
vendoring Git repositories, which we use across our projects. It provides an
easier alternative to submodules by committing upstream contents directly into
your repository while letting you easily manage and update them. Add this line
to your `DEPENDENCIES` file:

```
std https://github.com/sourcemeta/std v<x.y.z>
```

Then pull the library into your `vendor` directory:

```sh
./vendor/vendorpull/pull std
```

Reference the schemas using the
[`$ref`](https://www.learnjsonschema.com/2020-12/core/ref) keyword with a
relative path. For example:

```yaml
schema:
  type: object
  properties:
    email:
      $ref: './vendor/std/schemas/ietf/email/address.json'
```

## :mortar_board: Citing

If you use this library in your research or project, please cite it using the
DOI provided above. You can find citation information in various formats
(BibTeX, APA, etc.) by clicking the "Cite as" button on the [Zenodo
record](https://doi.org/10.5281/zenodo.17526561).

## :page_facing_up: License

While the project is publicly available on GitHub, it operates under a
[source-available license](https://github.com/sourcemeta/std/blob/main/LICENSE)
rather than a traditional open-source model. You may freely use these schemas
for non-commercial purposes, but commercial use requires a [paid commercial
license](https://www.sourcemeta.com/products/std#pricing).

*We are happy to discuss OEM and white-label distribution options for
incorporating these schemas into commercial products*.

## :handshake: Contributing

We welcome contributions! By sending a pull request, you agree to our
[contributing
guidelines](https://github.com/sourcemeta/.github/blob/main/CONTRIBUTING.md).
Meaningful contributions to this repository can be taken into consideration
towards a discounted (or even free) commercial license.

> [!TIP]
> Do you want to level up your JSON Schema skills? Check out
> [learnjsonschema.com](https://www.learnjsonschema.com), our growing JSON
> Schema documentation website, our [JSON Schema for
> OpenAPI](https://www.sourcemeta.com/courses/jsonschema-for-openapi) video
> course, and our O'Reilly book [Unifying Business, Data, and Code: Designing
> Data Products with JSON
> Schema](https://www.oreilly.com/library/view/unifying-business-data/9781098144999/).

## :email: Contact

If you have any questions or comments, don't hesitate in opening a ticket on
[GitHub Discussions](https://github.com/sourcemeta/std/discussions) or writing
to us at [hello@sourcemeta.com](mailto:hello@sourcemeta.com).
