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

const cache = new Map();

function createSchemaProxy(currentPath = '') {
  return new Proxy({}, {
    get(target, property) {
      if (typeof property !== 'string') {
        return undefined;
      }

      const newPath = currentPath ? `${currentPath}/${property}` : property;

      if (cache.has(newPath)) {
        return cache.get(newPath);
      }

      const schemaBasePath = path.join(__dirname, '..', 'schemas');
      const fullPath = path.join(schemaBasePath, newPath);

      const jsonPath = `${fullPath}.json`;
      if (fs.existsSync(jsonPath)) {
        try {
          const content = fs.readFileSync(jsonPath, 'utf8');
          const schema = JSON.parse(content);
          cache.set(newPath, schema);
          return schema;
        } catch (error) {
          return undefined;
        }
      }

      if (fs.existsSync(fullPath) && fs.statSync(fullPath).isDirectory()) {
        const proxy = createSchemaProxy(newPath);
        cache.set(newPath, proxy);
        return proxy;
      }

      return undefined;
    }
  });
}

module.exports = getSchema;
module.exports.schemas = createSchemaProxy();
