Mudkip 0.0.2
============

Elixir library for Markdown rendering.

Currently supports the most part of formatting features provided by "default" standard (version of Gruber-Swartz).

Requires only Elixir version 0.10.2+, no any additional libraries needed.

Full list of Markdown features realized in current Mudkip version can be found in `test.md` file.

Usage
-----

```elixir
iex(1)> Mudkip.compile("*this* __will__ be `formatted`")
"<p><em>this</em> <strong>will</strong> be <pre>formatted</pre>\n</p>"
iex(2)> String.slice Mudkip.compile_file("test.md"), 0, 50 
"<p>Headers:</p><h1>h1</h1><h2>h2</h2><h3>h3</h3><h"
```

TODO
----

* __refactor__
* ExUnit tests

License
-------
[WTFPL](http://www.wtfpl.net/)
