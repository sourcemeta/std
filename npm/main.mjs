import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

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

export default getSchema;
