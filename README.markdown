Sourcemeta JSON Schema Standard Library
=======================================

A growing collection of hand-crafted high-quality schemas by Sourcemeta.

> [!CAUTION]
> This repository is a work-in-progress and not ready for general use yet.

Roadmap
-------

This section tracks standards and specifications that should ideally be covered in this library. Checkmarks (✓) indicate completed schemas.

### IETF RFCs (Internet Engineering Task Force)

#### HTTP (Hypertext Transfer Protocol)
- ✓ [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110) - HTTP Semantics
  - ✓ Status codes (all classes, standard enum)
  - ✓ Methods (generic pattern, standard enum)
  - ✓ ETags (strong, weak, combined)
  - ✓ HTTP/HTTPS URLs
  - [ ] Header field names
  - [ ] Header field values
  - [ ] Content-Type values
  - [ ] Cache-Control directives
  - [ ] Accept header values
  - [ ] Content-Encoding values
  - [ ] Transfer-Encoding values
- [RFC 5789](https://www.rfc-editor.org/rfc/rfc5789) - PATCH Method (✓ included in method-standard)
- [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918) - WebDAV (✓ methods included in method-standard)
- [RFC 6265](https://www.rfc-editor.org/rfc/rfc6265) - HTTP State Management (Cookies)
  - [ ] Cookie names
  - [ ] Cookie values
  - [ ] Set-Cookie directives
- [RFC 7230-7235](https://www.rfc-editor.org/rfc/rfc7230) - HTTP/1.1 Message Syntax and Routing
  - [ ] Request-Line
  - [ ] Status-Line
- [RFC 7540](https://www.rfc-editor.org/rfc/rfc7540) - HTTP/2
- [RFC 9113](https://www.rfc-editor.org/rfc/rfc9113) - HTTP/2 (updated)

#### URI/URL (Uniform Resource Identifiers)
- ✓ [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986) - URI Generic Syntax
  - ✓ URI (generic)
  - ✓ URL
  - ✓ URN
  - ✓ URI references
  - ✓ Relative references
  - [ ] URI schemes (specific: ftp, file, ws, wss, etc.)
  - [ ] Authority component
  - [ ] Path segments
  - [ ] Query strings
  - [ ] Fragments

#### Email
- ✓ [RFC 5322](https://www.rfc-editor.org/rfc/rfc5322) - Internet Message Format
  - ✓ Email addresses
  - [ ] Email headers
  - [ ] Message-ID
- [RFC 6854](https://www.rfc-editor.org/rfc/rfc6854) - Group syntax in From and Sender headers
- [RFC 2045-2049](https://www.rfc-editor.org/rfc/rfc2045) - MIME
  - [ ] MIME types
  - [ ] Content-Type headers
  - [ ] Content-Disposition
  - [ ] Multipart boundaries

#### JSON Related
- ✓ [RFC 6901](https://www.rfc-editor.org/rfc/rfc6901) - JSON Pointer
- [RFC 6902](https://www.rfc-editor.org/rfc/rfc6902) - JSON Patch
  - [ ] JSON Patch operations
  - [ ] JSON Patch documents
- [RFC 7396](https://www.rfc-editor.org/rfc/rfc7396) - JSON Merge Patch
- ✓ [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457) - Problem Details for HTTP APIs
- [RFC 8259](https://www.rfc-editor.org/rfc/rfc8259) - JSON Data Interchange Format
  - [ ] JSON values (with strict validation)

#### Date and Time
- [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339) - Date and Time on the Internet
  - [ ] date-time format
  - [ ] date format
  - [ ] time format
  - [ ] duration format
- [RFC 2822](https://www.rfc-editor.org/rfc/rfc2822) - Internet Message Format (date-time)

#### Authentication and Security
- [RFC 7519](https://www.rfc-editor.org/rfc/rfc7519) - JSON Web Token (JWT)
  - [ ] JWT structure
  - [ ] JWT claims (standard and custom)
- [RFC 7515](https://www.rfc-editor.org/rfc/rfc7515) - JSON Web Signature (JWS)
- [RFC 7516](https://www.rfc-editor.org/rfc/rfc7516) - JSON Web Encryption (JWE)
- [RFC 7517](https://www.rfc-editor.org/rfc/rfc7517) - JSON Web Key (JWK)
- [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749) - OAuth 2.0
  - [ ] Authorization requests
  - [ ] Token responses
- [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414) - OAuth 2.0 Authorization Server Metadata

#### Identifiers
- [RFC 4122](https://www.rfc-editor.org/rfc/rfc4122) - UUID
  - [ ] UUID v1 (time-based)
  - [ ] UUID v4 (random)
  - [ ] UUID v5 (name-based SHA-1)
  - [ ] UUID generic format
- [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) - UUID (updated)
  - [ ] UUID v6 (time-ordered)
  - [ ] UUID v7 (Unix Epoch time-based)
  - [ ] UUID v8 (custom)

#### Network and IP
- [RFC 791](https://www.rfc-editor.org/rfc/rfc791) - Internet Protocol (IPv4)
  - [ ] IPv4 addresses
  - [ ] IPv4 CIDR notation
- [RFC 4291](https://www.rfc-editor.org/rfc/rfc4291) - IPv6 Addressing Architecture
  - [ ] IPv6 addresses (full, compressed)
  - [ ] IPv6 CIDR notation
- [RFC 1034](https://www.rfc-editor.org/rfc/rfc1034) - Domain Names
  - [ ] Domain names (DNS)
  - [ ] Hostnames
  - [ ] Fully qualified domain names (FQDN)
- [RFC 952](https://www.rfc-editor.org/rfc/rfc952) - Hostname specification
- [RFC 5952](https://www.rfc-editor.org/rfc/rfc5952) - IPv6 Address Text Representation

#### Language and Locale
- [RFC 5646](https://www.rfc-editor.org/rfc/rfc5646) / [BCP 47](https://www.rfc-editor.org/info/bcp47) - Language Tags
  - [ ] Language tags (e.g., en-US, zh-Hans)
  - [ ] Language subtags
  - [ ] Script subtags
  - [ ] Region subtags

#### Media Types
- [RFC 6838](https://www.rfc-editor.org/rfc/rfc6838) - Media Type Specifications
  - [ ] Media types (MIME types)
  - [ ] Type/subtype structure
  - [ ] Parameters

#### Other IETF Standards
- [RFC 1321](https://www.rfc-editor.org/rfc/rfc1321) - MD5 Message-Digest Algorithm
  - [ ] MD5 hash format
- [RFC 3174](https://www.rfc-editor.org/rfc/rfc3174) - SHA-1
  - [ ] SHA-1 hash format
- [RFC 6234](https://www.rfc-editor.org/rfc/rfc6234) - SHA-2 family
  - [ ] SHA-256 hash format
  - [ ] SHA-512 hash format
- [RFC 4648](https://www.rfc-editor.org/rfc/rfc4648) - Base16, Base32, Base64 Encodings
  - [ ] Base64 encoded strings
  - [ ] Base64URL encoded strings
  - [ ] Base32 encoded strings

### ISO Standards (International Organization for Standardization)

#### Date, Time, and Duration
- [ISO 8601-1:2019](https://www.iso.org/standard/70907.html) - Date and time representations
  - [ ] Date formats (YYYY-MM-DD, etc.)
  - [ ] Time formats (HH:MM:SS, etc.)
  - [ ] DateTime with timezone
  - [ ] Week dates
  - [ ] Ordinal dates
  - [ ] Duration (P notation)
  - [ ] Time intervals
  - [ ] Recurring time intervals

#### Language and Country Codes
- [ISO 639-1:2002](https://www.iso.org/standard/22109.html) - Language codes (2-letter)
  - [ ] Two-letter language codes (en, es, fr, etc.)
- [ISO 639-2:1998](https://www.iso.org/standard/4767.html) - Language codes (3-letter)
  - [ ] Three-letter language codes
- [ISO 3166-1](https://www.iso.org/iso-3166-country-codes.html) - Country codes
  - [ ] Alpha-2 codes (US, GB, JP, etc.)
  - [ ] Alpha-3 codes (USA, GBR, JPN, etc.)
  - [ ] Numeric codes
- [ISO 3166-2](https://www.iso.org/standard/72483.html) - Subdivision codes
  - [ ] Country subdivision codes (US-CA, GB-ENG, etc.)

#### Currency and Units
- [ISO 4217](https://www.iso.org/iso-4217-currency-codes.html) - Currency codes
  - [ ] Currency codes (USD, EUR, GBP, etc.)
  - [ ] Currency numbers
- ✓ [ISO 80000-1:2022](https://www.iso.org/standard/76921.html) - Quantities and units
  - ✓ Percentage (0-100)
  - [ ] Other units

#### Information Technology
- ✓ [ISO/IEC 2382:2015](https://www.iso.org/standard/63598.html) - Information technology vocabulary
  - ✓ Byte (non-negative integer)
  - [ ] Bit
  - [ ] Kilobyte, Megabyte, Gigabyte, etc.

### IEEE Standards (Institute of Electrical and Electronics Engineers)

#### POSIX (Portable Operating System Interface)
- ✓ [IEEE 1003.1 (POSIX.1-2017)](https://pubs.opengroup.org/onlinepubs/9699919799/) - POSIX.1
  - ✓ Absolute paths
  - ✓ Relative paths
  - ✓ Generic paths
  - [ ] File permissions (octal notation)
  - [ ] Process IDs
  - [ ] User IDs / Group IDs
  - [ ] File descriptors
  - [ ] Environment variable names
  - [ ] Shell command syntax

#### Floating Point
- [IEEE 754](https://standards.ieee.org/standard/754-2019.html) - Floating-Point Arithmetic
  - [ ] Special values (NaN, Infinity, -Infinity)
  - [ ] Subnormal numbers

### IANA Registries (Internet Assigned Numbers Authority)

- [Media Types](https://www.iana.org/assignments/media-types/)
  - [ ] Registered media types
- [Character Sets](https://www.iana.org/assignments/character-sets/)
  - [ ] Character set names
- [Time Zone Database](https://www.iana.org/time-zones)
  - [ ] IANA time zone identifiers (America/New_York, etc.)
- [Port Numbers](https://www.iana.org/assignments/service-names-port-numbers/)
  - [ ] Well-known ports (0-1023)
  - [ ] Registered ports (1024-49151)
  - [ ] Valid port range (0-65535)
- [HTTP Status Codes](https://www.iana.org/assignments/http-status-codes/)
  - [ ] Extended status codes beyond RFC 9110

### Software Licensing

- [SPDX](https://spdx.org/licenses/) - Software Package Data Exchange
  - [ ] SPDX license identifiers (MIT, Apache-2.0, GPL-3.0, etc.)
  - [ ] SPDX license expressions (MIT OR Apache-2.0)

### Versioning

- [Semantic Versioning 2.0.0](https://semver.org/)
  - [ ] Semantic version strings (MAJOR.MINOR.PATCH)
  - [ ] Pre-release versions
  - [ ] Build metadata
  - [ ] Version ranges

### Cryptography

- [Bitcoin](https://bitcoin.org/bitcoin.pdf)
  - [ ] Bitcoin addresses
  - [ ] Bitcoin transaction hashes
- [Ethereum](https://ethereum.org/)
  - [ ] Ethereum addresses
  - [ ] Ethereum transaction hashes

### Geographic and Geospatial

- [WGS 84](https://en.wikipedia.org/wiki/World_Geodetic_System) - World Geodetic System
  - [ ] Latitude (-90 to 90)
  - [ ] Longitude (-180 to 180)
  - [ ] Altitude

### Telecommunications

- [E.164](https://www.itu.int/rec/T-REC-E.164/) - International telephone numbers
  - [ ] Phone numbers (international format)
- [ISSN](https://www.issn.org/) - International Standard Serial Number
  - [ ] ISSN format
- [ISBN](https://www.isbn-international.org/) - International Standard Book Number
  - [ ] ISBN-10
  - [ ] ISBN-13

### Miscellaneous

- [Cron Expressions](https://en.wikipedia.org/wiki/Cron)
  - [ ] Cron schedule format
- Credit Cards
  - [ ] Credit card numbers (Luhn algorithm)
  - [ ] CVV codes
  - [ ] Expiration dates
- [MAC Addresses](https://standards.ieee.org/products-programs/regauth/)
  - [ ] MAC address formats (colon, hyphen, dot notation)
- [VIN](https://www.iso.org/standard/52200.html) - Vehicle Identification Number
  - [ ] VIN format (17 characters)
