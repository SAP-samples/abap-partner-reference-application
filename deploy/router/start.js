const approuter = require('@sap/approuter');

const ar = approuter();
ar.start({
  extensions: [ require('@sap/asp-middleware') ]
});
