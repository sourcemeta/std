const test = require('node:test');
const assert = require('node:assert');
const getSchema = require('..');

test('loads a valid schema', () => {
  const schema = getSchema('2020-12/misc/schema-like');
  assert.strictEqual(typeof schema, 'object');
  assert.strictEqual(schema.$schema, 'https://json-schema.org/draft/2020-12/schema');
  assert.strictEqual(schema.title, 'JSON Schema Document');
});

test('returns null for non-existent schema', () => {
  const schema = getSchema('nonexistent/schema/path');
  assert.strictEqual(schema, null);
});

test('returns null for invalid input types', () => {
  assert.strictEqual(getSchema(null), null);
  assert.strictEqual(getSchema(undefined), null);
  assert.strictEqual(getSchema(123), null);
  assert.strictEqual(getSchema({}), null);
});

test('blocks directory traversal attempts', () => {
  const schema = getSchema('../package');
  assert.strictEqual(schema, null);
});

test('blocks directory traversal with multiple levels', () => {
  const schema = getSchema('../../etc/passwd');
  assert.strictEqual(schema, null);
});

test('loads schema from nested path', () => {
  const schema = getSchema('2020-12/w3c/xmlschema/2001/hex-binary');
  assert.strictEqual(typeof schema, 'object');
  assert.strictEqual(schema.$schema, 'https://json-schema.org/draft/2020-12/schema');
});
