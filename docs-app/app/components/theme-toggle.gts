import { Toggle } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Moon, Sun } from './icons';

function toggleTheme() {
  if (colorScheme.current === 'dark') {
    colorScheme.update('light');
  } else {
    colorScheme.update('dark');
  }
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
