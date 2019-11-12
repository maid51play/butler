/* eslint-disable cypress/no-unnecessary-waiting */
// <reference types="Cypress" />

context('Maid Checkin', () => {
  beforeEach(() => {
    cy.factorydb('party', {});

    cy.login();
    cy.visit('localhost:4001/');
  });

  it('maid check in happy path', () => {
    cy.visit('localhost:4001/maids');
    cy.wait(30000);
    cy.visit('localhost:4001/reservations');
    cy.wait(30000);
    cy.visit('localhost:4001/tables');
    cy.wait(30000);
    cy.visit('localhost:4001/reservations/clear');
    cy.wait(30000);
    cy.visit('localhost:4001/waitlist');
    cy.wait(30000);
    // cy.contains('Maid Check In').click();

    // cy.contains('Maid Check-In').should('be.visible');

    // cy.contains('New maid').click();

    // cy.contains('New maid').should('be.visible');

    // cy.get('#maid_name')
    //   .type('Mikuru').should('have.value', 'Mikuru');

    // cy.contains('Submit').click();

    // cy.contains('Maid Mikuru created successfully.').should('be.visible');

    // cy.contains('td', 'Mikuru').parent().contains('Check In').click();

    // cy.contains('Maid Check In').click();

    // cy.contains('Tables').click();

    // cy.contains('Book').click();

    // cy.contains('Mikuru').should('be.visible');

    // cy.contains('Maid Check In').click();

    // cy.contains('td', 'Mikuru').parent().contains('Check Out').click();

    // cy.contains('Mikuru checked out successfully.').should('be.visible');
  });
});
