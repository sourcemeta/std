Sourcemeta JSON Schema Standard Library
=======================================

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

## :blue_book: Standards

This library provides schemas that encode aspects of the following standards.
Note that these standards often contain concepts and specifications that cannot
be represented as schemas. We extract and formalize the portions that can be
expressed as JSON Schema definitions.

| Organisation | Standard | Title |
|--------------|----------|-------|
| IEEE | [IEEE Std 1003.1-2017](https://pubs.opengroup.org/onlinepubs/9699919799/) | IEEE Standard for Information Technology—Portable Operating System Interface (POSIX) Base Specifications, Issue 7 |
| IETF | [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986) | Uniform Resource Identifier (URI): Generic Syntax |
| IETF | [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918) | HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV) |
| IETF | [RFC 5322](https://www.rfc-editor.org/rfc/rfc5322) | Internet Message Format |
| IETF | [RFC 5789](https://www.rfc-editor.org/rfc/rfc5789) | PATCH Method for HTTP |
| IETF | [RFC 6901](https://www.rfc-editor.org/rfc/rfc6901) | JavaScript Object Notation (JSON) Pointer |
| IETF | [RFC 7807](https://www.rfc-editor.org/rfc/rfc7807) | Problem Details for HTTP APIs |
| IETF | [RFC 8141](https://www.rfc-editor.org/rfc/rfc8141) | Uniform Resource Names (URNs) |
| IETF | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110) | HTTP Semantics |
| ISO | [ISO 4217](https://www.iso.org/iso-4217-currency-codes.html) | Codes for the representation of currencies and funds |
| ISO | [ISO 80000-1:2022](https://www.iso.org/standard/76921.html) | Quantities and units — Part 1: General |
| ISO/IEC | [ISO/IEC 2382:2015](https://www.iso.org/standard/63598.html) | Information technology — Vocabulary |
| JSON-RPC | [JSON-RPC 2.0](https://www.jsonrpc.org/specification) | JSON-RPC 2.0 Specification |
| JSON Schema | [Draft 2020-12](https://json-schema.org/draft/2020-12/json-schema-core) | JSON Schema: A Media Type for Describing JSON Documents |

To request coverage of another standard, please [open an issue on
GitHub](https://github.com/sourcemeta/std/issues).

## :page_facing_up: License

While the project is publicly available on GitHub, it operates under a
[source-available license](https://github.com/sourcemeta/std/blob/main/LICENSE)
rather than a traditional open-source model. You may freely use these schemas
for non-commercial purposes, but commercial use requires a [paid commercial
license](https://www.sourcemeta.com/#pricing).

**We are happy to discuss OEM and white-label distribution options for
incorporating these schemas into commercial products**

## :handshake: Contributing

We welcome contributions! By sending a pull request, you agree to our
[contributing
guidelines](https://github.com/sourcemeta/.github/blob/main/CONTRIBUTING.md).
Meaningful contributions to this repository can be taken into consideration
towards a discounted (or even free) commercial license.

> [!TIP]
> Do you want to level up your JSON Schema skills? Check out
> [learnjsonschema.com](https://www.learnjsonschema.com), our growing JSON
> Schema documentation website, and our O'Reilly book [Unifying Business, Data,
> and Code: Designing Data Products with JSON
> Schema](https://www.oreilly.com/library/view/unifying-business-data/9781098144999/).

## :email: Contact

If you have any questions or comments, don't hesitate in opening a ticket on
[GitHub Discussions](https://github.com/sourcemeta/std/discussions) or writing
to us at [hello@sourcemeta.com](mailto:hello@sourcemeta.com).
