import { assert as debugAssert } from '@ember/debug';
import {
  fillIn,
  find,
  findAll,
  focus,
  render,
  triggerEvent,
  triggerKeyEvent,
} from '@ember/test-helpers';
import { module, skip, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { OTPInput } from 'ember-primitives';

import { fillOTP } from 'ember-primitives/test-support';

function getInputs() {
  let inputs = find('fieldset')?.querySelectorAll('input');

  if (!inputs) return [];

  return [...inputs] as HTMLInputElement[];
}

function readValue() {
  return getInputs()
    .map((input) => input.value)
    .join('');
}

module('Rendering | <OTPInput>', function (hooks) {
  setupRenderingTest(hooks);

  test('@length: default number of inputs is 6', async function (assert) {
    await render(<template><OTPInput /></template>);

    assert.dom('input').exists({ count: 6 });
  });

  test('@length={{4}}', async function (assert) {
    await render(<template><OTPInput @length={{4}} /></template>);

    assert.dom('input').exists({ count: 4 });
  });

  test('<Fields> can be used', async function (assert) {
    await render(<template>
      <OTPInput as |Fields|>
        <out>my extra info</out>
        <Fields />
      </OTPInput>
    </template>);

    assert.dom('out').exists();
    assert.dom('input').exists({ count: 6 });
  });

  test('@onChange is called (and debounced)', async function (assert) {
    let step = ({ code, complete }: { code: string; complete: boolean }) =>
      assert.step(`${code}:${complete}`);

    await render(<template><OTPInput @onChange={{step}} /></template>);

    assert.strictEqual(readValue(), '');

    await fillOTP('1');

    assert.verifySteps(['1:false']);

    await fillOTP('12');

    assert.verifySteps(['12:false']);

    await fillOTP('123456');

    assert.verifySteps(['123456:true']);
  });

  test('@labelFn, by default, provides a predictable, default english label', async function (assert) {
    await render(<template><OTPInput /></template>);

    let inputs = findAll('input');
    let labels = findAll('label');

    assert.strictEqual(
      inputs.length,
      labels.length,
      'there are labels equal to the number of input fields'
    );

    labels.forEach((label, i) => {
      assert.dom(label).hasText(`Please enter OTP character ${i + 1}`);
    });
  });

  test('@labelFn can be specified to override the aria-label', async function (assert) {
    let label = (i: number) => `OTP#${i}`;

    await render(<template><OTPInput @labelFn={{label}} /></template>);

    let inputs = findAll('input');
    let labels = findAll('label');

    assert.strictEqual(
      inputs.length,
      labels.length,
      'there are labels equal to the number of input fields'
    );

    labels.forEach((label, i) => {
      assert.dom(label).hasText(`OTP#${i}`);
    });
  });

  test('individually typing in each field focuses the next', async function (assert) {
    await render(<template><OTPInput /></template>);

    assert.strictEqual(readValue(), '');

    let inputs = getInputs() as [
      HTMLInputElement,
      HTMLInputElement,
      HTMLInputElement,
      HTMLInputElement,
    ];

    for (let input of inputs) {
      assert.notEqual(document.activeElement, input);
    }

    await focus(inputs[0]);
    assert.strictEqual(document.activeElement, inputs[0]);

    await fillIn(inputs[0], '0');
    assert.strictEqual(document.activeElement, inputs[1]);

    await fillIn(inputs[1], '0');
    assert.strictEqual(document.activeElement, inputs[2]);

    await fillIn(inputs[2], '0');
    assert.strictEqual(document.activeElement, inputs[3]);
  });

  test('ArrowRight: moving to the right: arrow keys correctly change focus', async function (assert) {
    await render(<template><OTPInput /></template>);

    let inputs = getInputs();

    debugAssert('Missing Input', inputs[0]);
    debugAssert('Missing Input', inputs[1]);
    debugAssert('Missing Input', inputs[2]);
    debugAssert('Missing Input', inputs[3]);
    debugAssert('Missing Input', inputs[4]);
    debugAssert('Missing Input', inputs[5]);

    await focus(inputs[0]);
    assert.strictEqual(document.activeElement, inputs[0]);

    await triggerKeyEvent(inputs[0], 'keydown', 'ArrowLeft');
    assert.strictEqual(
      document.activeElement,
      inputs[0],
      `Can't go more left, we're at the beginning`
    );

    for (let i = 0; i < 5; i++) {
      let current = inputs[i];

      debugAssert('Incorrect index', current);
      await triggerKeyEvent(current, 'keydown', 'ArrowRight');
      assert.strictEqual(document.activeElement, inputs[i + 1]);
    }

    assert.strictEqual(
      document.activeElement,
      inputs[5],
      `make sure we're at the end after our loop`
    );

    await triggerKeyEvent(inputs[5], 'keydown', 'ArrowRight');
    assert.strictEqual(
      document.activeElement,
      inputs[5],
      `Can't go more right, we're already at the end`
    );
  });

  test('ArrowLeft: moving to the left: arrow keys correctly change focus', async function (assert) {
    await render(<template><OTPInput /></template>);

    let inputs = getInputs();

    debugAssert('Missing Input', inputs[0]);
    debugAssert('Missing Input', inputs[1]);
    debugAssert('Missing Input', inputs[2]);
    debugAssert('Missing Input', inputs[3]);
    debugAssert('Missing Input', inputs[4]);
    debugAssert('Missing Input', inputs[5]);

    await focus(inputs[5]);
    assert.strictEqual(document.activeElement, inputs[5]);

    await triggerKeyEvent(inputs[5], 'keydown', 'ArrowRight');
    assert.strictEqual(document.activeElement, inputs[5], `Can't go more right, we're at the end`);

    for (let i = 5; i > 0; i--) {
      let current = inputs[i];

      debugAssert('Incorrect index', current);
      await triggerKeyEvent(current, 'keydown', 'ArrowLeft');
      assert.strictEqual(document.activeElement, inputs[i - 1]);
    }

    assert.strictEqual(
      document.activeElement,
      inputs[0],
      `make sure we're at the end after our loop`
    );

    await triggerKeyEvent(inputs[0], 'keydown', 'ArrowLeft');
    assert.strictEqual(
      document.activeElement,
      inputs[0],
      `Can't go more left, we're already at the beginning`
    );
  });

  // Backspace can only work when isTrusted:true
  // how do we test the backspace behavior?
  //
  // NOTE: this test is incomplete and probably wrong as is.
  //       there are some debugging artifacts in here
  skip('backspace behavior after a full code is entered', async function (assert) {
    await render(<template><OTPInput /></template>);

    await fillOTP('123456');

    assert.strictEqual(readValue(), '123456');

    let inputs = getInputs();

    debugAssert('Missing Input', inputs[0]);
    debugAssert('Missing Input', inputs[1]);
    debugAssert('Missing Input', inputs[2]);
    debugAssert('Missing Input', inputs[3]);
    debugAssert('Missing Input', inputs[4]);
    debugAssert('Missing Input', inputs[5]);

    debugAssert(`Missing i:5`, inputs[5]);
    await focus(inputs[5]);
    // assert.strictEqual(inputs[5].selectionStart, 1, 'cursor is at the beginning of the text field');
    assert.dom(inputs[5]).hasValue('6');
    inputs[5].select();
    await triggerEvent(inputs[5], 'input', { key: 'Backspace', isTrusted: true });
    await this.pauseTest();
    assert.dom(inputs[5]).hasValue('');
    assert.strictEqual(document.activeElement, inputs[5]);
  });
});
