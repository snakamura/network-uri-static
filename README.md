# network-uri-static

[![Join the chat at https://gitter.im/snakamura/network-uri-static](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/snakamura/network-uri-static?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`network-uri-static` is a small utility for Haskell that allows you to declare static URIs in type-safe manner.

## Tutorial

When you declare a static URI, you need to either use `Maybe URI` or use `URI` and give up type safety.

```haskell
safeButWrappedInMaybeURI :: Maybe URI
safeButWrappedInMaybeURI = parseURI "http://www.google.com/"

directButUnsafeURI :: URI
directButUnsafeURI = fromJust $ parseURI "http://www.google.com/"
```

This library allows you to write static URIs in type-safe manner by checking URIs at compile time using template haskell.

Now, you can write the following.

```haskell
directAndSafeURI :: URI
directAndSafeURI = $$(staticURI "http://www.google.com")
```

You can even use a quasi quote if you'd like.

```haskell
directAndSafeURI :: URI
directAndSafeURI = [uri|"http://www.google.com"|]
```

These two expressions emit an error at compile time if a specified URI is malformed.

## License (MIT)

Copyright (c) 2015 Satoshi Nakamura

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
