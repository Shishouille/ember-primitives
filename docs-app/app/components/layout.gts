import { ExternalLink, service } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Footer } from './footer';
import { Nav, titleize } from './nav';
import { Prose } from './prose';
import { SecondaryNav } from './secondary-nav';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

function isDark() {
  return colorScheme.current === 'dark';
}

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;

<template>
  {{#let (service "selected") as |page|}}
    {{#if page.prose}}

      {{(removeAppShell)}}

      {{#if (isDark)}}
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-dark.css"
        />
      {{else}}
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-light.css"
        />
      {{/if}}

      <main id="layout">
        <Nav />
        <section id="main-section">
          <SecondaryNav />
          <div id="content">
            {{#if page.section}}
              <h2 class="section-header">{{titleize page.section}}</h2>
            {{/if}}
            <Prose />
          </div>
          <Footer />
        </section>
      </main>
    {{else if page.hasError}}
      <h1>Oops!</h1>
      {{page.error}}

      <br />
      <br />
      If you have a GitHub account (and the time),
      <ReportingAnIssue />
      would be most helpful! 🎉
    {{/if}}
  {{/let}}
</template>
