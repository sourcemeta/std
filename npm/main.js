const fs = require('fs');
const path = require('path');

function getSchema(schemaPath) {
  if (!schemaPath || typeof schemaPath !== 'string') {
    return null;
  }

  if (schemaPath.includes('..')) {
    return null;
  }

  const absolutePath = path.join(__dirname, '..', 'schemas', `${schemaPath}.json`);

  try {
    const content = fs.readFileSync(absolutePath, 'utf8');
    return JSON.parse(content);
  } catch (error) {
    return null;
  }
}

module.exports = getSchema;
