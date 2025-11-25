import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const getSchema = require('./main.js');

export const schemas = getSchema.schemas;
export default getSchema;
