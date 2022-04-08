// <reference types="Cypress" />

context('Login', () => {
  beforeEach(() => {
    cy.visit('localhost:4001/admin');
  });

  it('displays unathenticated error when accessing pages without logging in', () => {
    cy.contains('Cafe Data').click();

    cy.contains('unauthenticated').should('be.visible');
  });

  it('displays an error when username and password are incorrect', () => {
    cy.get('#user_username')
      .type('fake@email.com').should('have.value', 'fake@email.com');

    cy.get('#user_password')
      .type('password');

    cy.contains('Submit')
      .click();

    cy.contains('Incorrect username or password').should('be.visible');

    cy.contains('Cafe Data').click();

    cy.contains('unauthenticated').should('be.visible');
  });

  it('authenticates when username and password are correct', () => {
    cy.factorydb('user', {
      username: 'admin',
    });

    cy.get('#user_username')
      .type('admin').should('have.value', 'admin');

    cy.get('#user_password')
      .type('password');

    cy.contains('Submit')
      .click();

    cy.contains('Logout').should('be.visible');

    cy.contains('Cafe Data').click();

    cy.contains('Total Reservations').should('be.visible');
  });
});
