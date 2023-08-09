# Link

```gjs live no-shadow
import { CommentQuery } from 'docs-app/docs-support';

<template>
  <CommentQuery @module="components/link" @name="Link" />
</template>
```

## Example


```gjs live preview
import { Link } from 'ember-primitives';

<template>
  <Link @href="/">Home</Link>  &nbsp;&nbsp;

  <Link @href="https://developer.mozilla.org" as |a|>
    MDN

    {{#if a.isExternal}}
      ➚
    {{/if}}
  </Link>
</template>
```

## Features

* Full keyboard navigation
* Active state
* "Just an `<a>`" 

## Anatomy

_requires usage of [`@properLinks`](/4-routing/proper-links)_


```js 
import { Link } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Link } from 'ember-primitives/components/link';
```


```gjs 
import { Link } from 'ember-primitives';

<template>
  <Link @href="..." as |a|>
    {{if a.isActive "active!"}}
    {{if a.isExternal "external!"}}
  </Link>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/link" @name="Signature" />
</template>
```

### State Attributes


| key | description |  
| :---: | :----------- |  
| data-active | attribute will be "true" or "false", depending on if the `@href` matches the current URL |  

<br>

```gjs live preview
import { Link } from 'ember-primitives';

<template>
  <style>
    [data-active] {
      color: red;
    }
    a { padding: 0.25rem 0.5rem; }
  </style>

  <Link @href="/4-routing/link" as |a|>
    This page
  </Link>
  |
  <Link @href="/4-routing/proper-links" as |a|>
    Related page
  </Link>
</template>
```


