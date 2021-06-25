# Overview

NY Times News App.

https://user-images.githubusercontent.com/26793088/123346614-9077e600-d50d-11eb-8268-f5291496fc6c.mp4

## Installation

```zsh
### create secret file
$ API_KEY=xxxx
$ APP_ID=yyyyy
$ to=nytimes/SupportFiles/Secret.swift
$ echo "let NY_TIMES_API_KEY = \"$API_KEY\"\nlet NY_TIMES_APP_ID = \"$APP_ID\"" > $to
$ cat $to
```

## Features

### Search Specification

- Exact string matches, no fuzzy.
- OR query opereting

## Tech

- Core: Swift 5.4 + UIKit
- Packages: Not using any packages and pods
- Architecture: MVC/MVVM

## REF

- [NY Times Search API](https://developer.nytimes.com/docs/articlesearch-product/1/overview)

## LICENSE

MIT
