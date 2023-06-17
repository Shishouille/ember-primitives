import * as docsSupport from 'docs-app/docs-support';
import * as emberHeadlessForm from 'ember-headless-form';
import * as emberPrimitives from 'ember-primitives';
import * as colorScheme from 'ember-primitives/color-scheme';
import * as emberResources from 'ember-resources';
import * as remoteData from 'ember-resources/util/remote-data';

import type { Options } from './compiler';

export const defaultOptions: Options = {
  format: 'glimdown',
  importMap: {
    'ember-primitives': emberPrimitives,
    'ember-primitives/color-scheme': colorScheme,
    'ember-headless-form': emberHeadlessForm,
    'ember-resources': emberResources,
    'ember-resources/util/remote-data': remoteData,
    'docs-app/docs-support': docsSupport,
  },
};