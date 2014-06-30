neco-php
========

A neocomplcache plugin for PHP completion.

Usage
-----
The plugin is a source plugin of neocomplcache -- https://github.com/Shougo/neocomplcache, you need install neocomplcache first.


    Bundle 'Shougo/neocomplcache'
    Bundle 'brookhong/neco-php'

Multiple sources
--------------

    let g:neco_php_default_sources='functions,phpunit'

Files named functions.dict and phpunit.dict will be loaded as candidates source.You can add more sources by building your own dictionaries. Candidates source update dynamicly.

Screen shot
----------
![neco-php](http://sharing-from-brook.16002.n6.nabble.com/file/n4967529/neco-php.png)
