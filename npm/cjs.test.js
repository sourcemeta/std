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

test('lazy loads schema via schemas object', () => {
  const { schemas } = require('..');
  const schema = schemas['2020-12'].misc['schema-like'];
  assert.strictEqual(typeof schema, 'object');
  assert.strictEqual(schema.title, 'JSON Schema Document');
});

test('caches loaded schemas', () => {
  const { schemas } = require('..');
  const schema1 = schemas['2020-12'].misc['schema-like'];
  const schema2 = schemas['2020-12'].misc['schema-like'];
  assert.strictEqual(schema1, schema2);
});

test('handles deeply nested paths', () => {
  const { schemas } = require('..');
  const schema = schemas['2020-12'].w3c.xmlschema['2001']['hex-binary'];
  assert.strictEqual(typeof schema, 'object');
  assert.strictEqual(schema.$schema, 'https://json-schema.org/draft/2020-12/schema');
});

test('returns undefined for non-existent directories', () => {
  const { schemas } = require('..');
  const result = schemas['2020-12'].nonexistent;
  assert.strictEqual(result, undefined);
});

test('returns undefined for non-existent files', () => {
  const { schemas } = require('..');
  const result = schemas['2020-12'].misc['nonexistent-file'];
  assert.strictEqual(result, undefined);
});
