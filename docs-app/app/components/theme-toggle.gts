import { Toggle } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Moon, Sun } from './icons';

function syncBodyClass() {
  // if (colorScheme.current === 'dark') {
  //   document.documentElement.setAttribute('data-theme', 'dark');
  // } else {
  //   document.documentElement.setAttribute('data-theme', 'light');
  // }
}

function toggleTheme() {
  if (colorScheme.current === 'dark') {
    colorScheme.update('light');
  } else {
    colorScheme.update('dark');
  }

  syncBodyClass();
}

function isDark() {
  return colorScheme.current === 'dark';
}

export const ThemeToggle = <template>
  <Toggle
    aria-label="Toggle between light and dark mode"
    id="site-theme-toggle"
    @onChange={{toggleTheme}}
  >
    {{#if (isDark)}}
      <Sun />
    {{else}}
      <Moon />
    {{/if}}
  </Toggle>
</template>;
