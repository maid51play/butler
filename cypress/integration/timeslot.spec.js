/* eslint-disable cypress/no-unnecessary-waiting */
// <reference types="Cypress" />

context('Timeslots', () => {
  beforeEach(() => {
    const now = new Date('2017-03-14T15:00:00.000+08:00');
    cy.clock(now);

    cy.login();
    cy.visit('localhost:4001/admin');
  });

  it('timeslot happy path', () => {
    cy.contains('Timeslots').click();

    cy.contains('Listing Timeslots').should('be.visible');

    cy.contains('New Timeslot').click();

    cy.contains('New Timeslot').should('be.visible');

    cy.get('#timeslot_start_time_year')
      .select('2017').should('have.value', '2017');
    cy.get('#timeslot_start_time_month')
      .select('3').should('have.value', '3');
    cy.get('#timeslot_start_time_day')
      .select('14').should('have.value', '14');
    cy.get('#timeslot_start_time_hour')
      .select('12').should('have.value', '12');

    cy.contains('Save').click();

    cy.contains('Oops, something went wrong! Please check the errors below.').should('be.visible');
    cy.contains('End time must be after start time').should('be.visible');

    cy.get('#timeslot_end_time_year')
      .select('2017').should('have.value', '2017');
    cy.get('#timeslot_end_time_month')
      .select('3').should('have.value', '3');
    cy.get('#timeslot_end_time_day')
      .select('14').should('have.value', '14');
    cy.get('#timeslot_end_time_hour')
      .select('13').should('have.value', '13');

    cy.contains('Save').click();

    cy.contains('Timeslot created successfully.').should('be.visible');
    cy.contains('Show Timeslot').should('be.visible');
    cy.contains('2017-03-14 12:00:00').should('be.visible');
    cy.contains('2017-03-14 13:00:00').should('be.visible');

    cy.contains('Edit').click();

    cy.get('#timeslot_end_time_hour')
      .select('14').should('have.value', '14');

    cy.get('#timeslot_start_time_hour')
      .select('13').should('have.value', '13');

    cy.contains('Save').click();

    cy.contains('Timeslot updated successfully.').should('be.visible');
    cy.contains('Show Timeslot').should('be.visible');
    cy.contains('2017-03-14 13:00:00').should('be.visible');
    cy.contains('2017-03-14 14:00:00').should('be.visible');

    cy.contains('Back').click();
    cy.contains('2017-03-14 13:00:00').should('be.visible');
    cy.contains('2017-03-14 14:00:00').should('be.visible');

    cy.visit('localhost:4001/book');

    cy.contains('Tuesday, March 14');
    // TODO: Add booking flow
  });
});
