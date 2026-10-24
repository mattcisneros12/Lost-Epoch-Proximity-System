// Exercises the shipped inline script and its rendered DOM state without dependencies.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const html = fs.readFileSync(`${__dirname}/../dashboard/index.html`, 'utf8');
const elements = new Map();
for (const match of html.matchAll(/<[^>]+\bid="([^"]+)"[^>]*>/g)) {
  const tag = match[0];
  elements.set(match[1], { value: /\bvalue="([^"]*)"/.exec(tag)?.[1] ?? '', style: {}, attributes: {}, listeners: {},
    setAttribute(key, value) { this.attributes[key] = value; },
    addEventListener(type, callback) { this.listeners[type] = callback; } });
}
const el = id => elements.get(id);
el('soundType').value = 'voice'; el('source').value = 'a'; el('voiceMode').value = 'normal';
const context = vm.createContext({ document: { getElementById: el } });
vm.runInContext(/<script>([\s\S]*?)<\/script>/.exec(html)[1], context);
let checks = 0;
for (const [type, mode, source, range] of [
  ['voice', 'whisper', 'a', 15], ['voice', 'normal', 'a', 60], ['voice', 'shout', 'a', 125],
  ['roar', 'normal', 'a', 710], ['roar', 'normal', 'b', 125]
]) {
  for (const speaker of type === 'voice' ? ['a', 'b'] : [source]) {
    for (const delta of [-1, 0, 1]) {
      el('ax').value = '0'; el('ay').value = '0'; el('bx').value = String(range + delta); el('by').value = '0';
      el('soundType').value = type; el('voiceMode').value = mode; el('source').value = speaker;
      el('bx').listeners.input();
      assert.equal(el('statusValue').textContent, delta <= 0 ? 'WITHIN RANGE' : 'OUT OF RANGE');
      assert.equal(el('rangeValue').textContent, `${range} m`);
      assert.equal(el('distanceValue').textContent, `${(range + delta).toFixed(2)} m`);
      if (delta >= 0) assert.equal(el('volumeValue').textContent, '0%');
      assert.equal(el('volumeBar').style.width, el('volumeValue').textContent);
      assert.equal(el('voiceControls').hidden, type !== 'voice');
      const marker = el(speaker === 'a' ? 'markerA' : 'markerB');
      assert.equal(el('soundRadius').attributes.cx, marker.attributes.cx);
      checks++;
    }
  }
}
el('resetButton').listeners.click();
assert.equal(el('distanceValue').textContent, '40.00 m');
assert.match(html, /exact range boundary[\s\S]*?0%/i);
console.log(`PASS: ${checks} dashboard boundary cases plus reset and boundary explanation`);
