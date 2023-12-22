import type { TOC } from '@ember/component/template-only';

export const Callout: TOC<{ Blocks: { default: [] } }> = <template>
  <div class="callout">
    <span class="icon">✨</span>
    <p class="text">
      {{yield}}
    </p>
  </div>
</template>;

export default Callout;
