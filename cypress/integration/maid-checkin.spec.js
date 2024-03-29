/* eslint-disable cypress/no-unnecessary-waiting */
// <reference types="Cypress" />

context('Maid Checkin', () => {
  beforeEach(() => {
    cy.factorydb('barcode', {});

    cy.login();
    cy.visit('localhost:4001/admin');
  });

  it('maid check in happy path', () => {
    cy.contains('Maid Check In').click();

    cy.contains('Maid Check-In').should('be.visible');

    cy.contains('New maid').click();

    cy.contains('New maid').should('be.visible');

    cy.get('#maid_name')
      .type('Mikuru').should('have.value', 'Mikuru');

    cy.contains('Submit').click();

    cy.contains('Maid Mikuru created successfully.').should('be.visible');

    cy.contains('td', 'Mikuru').parent().contains('Check In').click();

    cy.contains('td', 'Mikuru').parent().contains('0:00').should('be.visible');

    cy.clock(new Date().getTime() + 606000);

    cy.contains('Maid Check In').click();

    cy.contains('td', 'Mikuru').parent().contains('0:10').should('be.visible');

    cy.contains('Tables').click();

    cy.contains('Book').click();

    cy.contains('Mikuru').should('be.visible');

    cy.contains('Maid Check In').click();

    cy.contains('td', 'Mikuru').parent().contains('Check Out').click();

    cy.contains('Mikuru checked out successfully.').should('be.visible');
  });
});
