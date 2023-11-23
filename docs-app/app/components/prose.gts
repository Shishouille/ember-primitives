import { modifier } from 'ember-modifier';
import { service } from 'ember-primitives';

import { highlight } from './highlight';

import type { TOC } from '@ember/component/template-only';

const resetScroll = modifier((element, [prose]) => {
  prose;
  element.scrollTo(0, 0);
});

export const Prose: TOC<{ Element: HTMLDivElement }> = <template>
  {{#let (service "docs") as |docs|}}

    <div ...attributes {{resetScroll docs.selected.prose}}>

      <div data-prose class="prose" {{highlight docs.selected.prose}}>
        {{#if docs.selected.prose}}
          <docs.selected.prose />
        {{/if}}
      </div>

    </div>
  {{/let}}
</template>;
