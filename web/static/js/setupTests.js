// setup file
require('regenerator-runtime/runtime');
require('core-js/stable');
const enzyme = require('enzyme');
const Adapter = require('enzyme-adapter-react-16');

enzyme.configure({ adapter: new Adapter() });
