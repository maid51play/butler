// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })
Cypress.Commands.add('resetdb', () => {
  cy.exec('mix do ecto.drop, ecto.create, ecto.migrate');
});

Cypress.Commands.add('checkoutdb', () => {
  cy.request('POST', 'http://localhost:4001/api/end-to-end/db/checkout').as('checkoutDb');
});

Cypress.Commands.add('checkindb', () => {
  cy.request('POST', 'http://localhost:4001/api/end-to-end/db/checkin').as('checkinDb');
});

Cypress.Commands.add('factorydb', (schema, attrs) => {
  cy.log(`Creating a ${schema} via fullstack factory`);
  cy.request('POST', 'http://localhost:4001/api/end-to-end/db/factory', {
    schema,
    attributes: attrs,
  }).as('factoryDb');
});

Cypress.Commands.add('login', () => {
  cy.factorydb('user', {
    username: 'admin',
  });
  cy.visit('localhost:4001/admin');
  cy.get('#user_username')
    .type('admin').should('have.value', 'admin');

  cy.get('#user_password')
    .type('password');

  cy.contains('Submit')
    .click();
});
