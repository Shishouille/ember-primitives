import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { Link } from 'ember-primitives';
import { isLink } from 'ember-primitives/proper-links';

import type { TOC } from '@ember/component/template-only';
import type DocsService from 'docs-app/services/docs';
import type { Page } from 'docs-app/services/types';
import type UI from 'docs-app/services/ui';
import type RouterService from '@ember/routing/router-service';

/**
 * Converts 1-2-hyphenated-thing
 * to
 *   Hyphenated Thing
 */
export const titleize = (str: string) => {
  return (
    str
      .split('-')
      .filter((text) => !text.match(/^[\d]+$/))
      .map((text) => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`)
      .join(' ')
      .split('.')[0] || ''
  );
};

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};

const isComponents = (str: string) => str === 'components';
const isLoneIndex = (pages: Page[]) =>
  (pages.length === 1 && pages[0]?.name === 'index.md') || pages[0]?.name === 'intro.md';

const unExct = (str: string) => str.replace(/\.md$/, '');

const NameLink: TOC<{ Element: HTMLAnchorElement; Args: { href: string; name: string } }> =
  <template>
    <Link @href={{unExct @href}} ...attributes>
      {{#if (isComponents @name)}}
        {{asComponent (titleize @name)}}
      {{else}}
        {{(titleize @name)}}
      {{/if}}
    </Link>
  </template>;

export class Nav extends Component {
  @service declare docs: DocsService;
  @service declare ui: UI;
  @service declare router: RouterService;

  get humanSelected() {
    let path = this.docs.selected?.path;

    if (!path) return;

    return path.split('/').filter(Boolean).map(titleize).join(' / ');
  }

  isSelected = ({ path }: { path: string }) => {
    return this.docs.selected?.path === path;
  };

  closeNav = (event: Event) => {
    if (!isLink(event)) return;

    this.ui.isNavOpen = false;
  };

  isActive = (link: string) => {
    return this.router.currentURL === unExct(link);
  };

  /**
   *
   * This nav needs an aria-label to get around
   *  "Ensure landmarks are unique"
   *  because some demos render navs, and it's important that those
   *  demos are as simple as possible.
   *
   *
   *  nav isn't actually made in to an interactive element,
   *  it's an event delegation handler.
   *  The links themselves remain the actual interactive elements.
   */
  <template>
    <nav aria-label="Main Navigation" class={{if this.ui.isNavOpen "open"}} id="nav">
      <a href="/">ember-primitives</a>
      <ul class="nav-section">
        {{#each-in this.docs.grouped as |group pages|}}
          <li class="nav-item">
            {{#if (isLoneIndex pages)}}
              {{#each pages as |page|}}
                <NameLink
                  @name={{group}}
                  @href={{page.path}}
                  {{on "click" this.closeNav}}
                  class="nav-link {{if (this.isActive page.path) 'active'}}"
                />
              {{/each}}
            {{else}}
              <h2 class="nav-title">{{titleize group}}</h2>
              <ul class="nav-subsection">
                {{#each pages as |page|}}
                  <li class="nav-subitem nav-link {{if (this.isActive page.path) 'active'}}">
                    <NameLink
                      @name={{page.name}}
                      @href={{page.path}}
                      {{on "click" this.closeNav}}
                    />
                  </li>
                {{/each}}
              </ul>
            {{/if}}
          </li>
        {{/each-in}}
      </ul>
    </nav>
  </template>
}
