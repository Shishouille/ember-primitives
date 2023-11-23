import { on } from '@ember/modifier';
import { get } from '@ember/object';

import { ExternalLink, service } from 'ember-primitives';

import { Flask, GitHub } from './icons';
import { ThemeToggle } from './theme-toggle';

export const Footer = <template>
  {{#let (service "docs") as |docs|}}
    <footer id="footer">
      <hr class="border" />
      <ExternalLink
        class="edit-page"
        href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{docs.selected.path}}.md"
      >
        Edit this page
      </ExternalLink>
    </footer>
  {{/let}}
</template>;
