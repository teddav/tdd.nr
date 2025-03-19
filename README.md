# 2D-Doc

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Noir](https://img.shields.io/badge/Built%20With-Noir-blue)](https://noir-lang.org/)

**tdd.nr** is a **Noir** library designed to verify **[2D-Doc](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc) barcodes** using zero-knowledge proofs. 

This library enables privacy-preserving verification of structured documents, such as invoices, identity papers, and certificates, without revealing sensitive data.

Use cases include:

- **Identity verification**: validate government-issued documents.
- **Financial transactions**: authenticate invoices and receipts.
- **Supply chain compliance**: verify authenticity of regulatory documents.

## How it works

The [2D-Doc](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc) is a structured digital signature standard widely used for secure document authentication.

Components:

- **[2D-Doc](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc)** barcode for documents.
- **[Noir](https://noir-lang.org/)**: ensuring efficient and privacy-preserving computations.


---

## How to use

### Use in your project

In Nargo.toml file, add the following dependency:

```rust
[dependencies]
tdd = { git = "https://github.com/teddav/tdd.nr", tag = "main" }
```

### Import the library

Add this line:

```rust
use tdd::*;
```

## Example

You can find an example in [./examples/tdd1](./examples/tdd1)

---

## Contributing

Contributions are welcome! To get started:

- Fork this repository.
- Create a feature branch for your changes.
- Submit a pull request detailing your improvements.

---

## Sponsor
<p align="left">
  <a href="https://hyle.eu" target="_blank"> <img src="https://blog.hyle.eu/content/images/2024/10/Hyl-_widelogo_lightbg.png" width="15%", height="15%"/></a>
</p>

*This project is supported by [Hylé](https://hyle.eu), the next-gen base layer for unchained apps.*
