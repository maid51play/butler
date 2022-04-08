// <reference types="Cypress" />

context('Waitlist seating', () => {
  let tableA1;
  let tableA2;
  let barcode1;
  let barcode2;
  let barcode3;
  let barcode4;

  beforeEach(() => {
    tableA1 = { table_number: 'A1', max_capacity: '8' };
    tableA2 = { table_number: 'A2', max_capacity: '8' };
    barcode1 = {};
    barcode2 = {};
    barcode3 = {};
    barcode4 = {};

    cy.factorydb('table', tableA1)
      .then((result) => { tableA1.id = result.body.id; })
      .then(() => cy.factorydb('barcode', { table_id: tableA1.id }))
      .then((result) => {
        barcode1 = { table_id: tableA1.id, id: result.body.id };
      })
      .then(() => {
        tableA1.barcodes = [barcode1.id];
      });

    cy.factorydb('maid', {
      name: 'Kotori',
      status: 'present',
      checked_in_at: new Date(),
    });

    cy.login();

    cy.visit('localhost:4001/admin');
  });

  it('waitlist happy path', () => {
    cy.contains('Waitlist').click();

    cy.contains('Waitlist').should('be.visible');

    cy.contains('New reservation').click();

    cy.contains('New Waitlist Reservation').should('be.visible');

    cy.get('#reservation_name')
      .type('Honoka').should('have.value', 'Honoka');

    cy.get('#reservation_size')
      .type('9').should('have.value', '9');

    cy.get('#reservation-notes')
      .type("She knows we only seat up to parties of 8. She doesn't care.")
      .should('have.value', "She knows we only seat up to parties of 8. She doesn't care.");

    cy.contains('Submit').click();

    cy.contains('Reservation created successfully.').should('be.visible');

    cy.contains('td', 'Honoka').parent().contains('Edit').click();

    cy.contains('Edit Waitlist Reservation').should('be.visible');

    cy.get('#reservation_name')
      .clear()
      .type('Hanayo').should('have.value', 'Hanayo');

    cy.get('#reservation_size')
      .clear()
      .type('6').should('have.value', '6');

    cy.get('#reservation-notes')
      .clear()
      .type('Honoka forgot that the 3rd years already graduated and Hanayo is the club leader now.');

    cy.contains('Submit').click();

    cy.contains('Reservation updated successfully.').should('be.visible');

    cy.contains('Hanayo').should('be.visible');

    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Hanayo').parent().contains('Edit').click();

    cy.contains('Edit Waitlist Reservation').should('be.visible');

    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Hanayo').parent().contains('Select').click();

    cy.contains('Seating party of 6 for Hanayo.').should('be.visible');

    cy.contains('Cancel').click();

    cy.contains('Seating party of 6 for Hanayo.').should('not.be.visible');

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Hanayo').parent().contains('Select').click();

    cy.contains('A1').parent().contains('Book').click();

    cy.contains('Seating party of 6 for Hanayo.').should('be.visible');

    cy.contains('Kotori').click();

    // mocking the barcode input
    cy.window().then((win) => {
      // eslint-disable-next-line no-param-reassign, prefer-destructuring
      win.document.getElementById('reservation_barcode_id').value = tableA1.barcodes[0];
    });

    cy.contains('Submit').click();

    cy.contains('Reservation updated successfully.').should('be.visible');

    cy.contains('Tables').click();

    cy.contains('td', 'Kotori').parent().children().first()
      .next()
      .should('have.text', '8')
      .next()
      .should('have.text', '2')
      .next()
      .next()
      .should('have.text', '6')
      .next()
      .should('have.text', 'a few seconds');

    cy.contains('Clear Party').click();

    // mocking the barcode input
    cy.window().then((win) => {
      // eslint-disable-next-line no-param-reassign, prefer-destructuring
      win.document.getElementById('reservation_barcode_id').value = tableA1.barcodes[0];
    });

    cy.contains('Submit').click();

    cy.contains('Reservation cleared successfully.').should('be.visible');
  });

  it('waitlist with seat alone happy path', () => {
    cy.factorydb('reservation', { barcode_id: barcode1.id, table_number: 'A1' });

    cy.factorydb('barcode', { table_id: tableA1.id })
      .then((result) => {
        barcode2 = { table_id: tableA1.id, id: result.body.id };
      })
      .then(() => {
        tableA1.barcodes = [...tableA1.barcodes, barcode2.id];
      });

    cy.factorydb('table', tableA2)
      .then((result) => { tableA2.id = result.body.id; })
      .then(() => cy.factorydb('barcode', { table_id: tableA2.id }))
      .then((result) => {
        barcode3 = { table_id: tableA2.id, id: result.body.id };
      })
      .then(() => cy.factorydb('barcode', { table_id: tableA2.id }))
      .then((result) => {
        barcode4 = { table_id: tableA2.id, id: result.body.id };
      })
      .then(() => {
        tableA2.barcodes = [barcode3.id, barcode4.id];
      });

    // create a seat alone reservation
    cy.contains('Waitlist').click();

    cy.contains('Waitlist').should('be.visible');

    cy.contains('New reservation').click();

    cy.contains('New Waitlist Reservation').should('be.visible');

    cy.get('#reservation_name')
      .type('Bocchi').should('have.value', 'Bocchi');

    cy.get('#reservation_size')
      .type('1').should('have.value', '1');

    cy.contains('Seat Alone').click();

    cy.contains('Submit').click();

    cy.contains('Reservation created successfully.').should('be.visible');

    cy.contains('Bocchi').parent().contains('💖').should('be.visible');

    // create a non-seat alone reservation
    cy.contains('New reservation').click();

    cy.contains('New Waitlist Reservation').should('be.visible');

    cy.get('#reservation_name')
      .type('Nako').should('have.value', 'Nako');

    cy.get('#reservation_size')
      .type('1').should('have.value', '1');

    cy.contains('Submit').click();

    cy.contains('Reservation created successfully.').should('be.visible');

    cy.contains('Nako').parent().contains('💖').should('not.be.visible');

    // book button for table with a party already seated should be greyed out
    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Bocchi').parent().contains('Select').click();

    cy.contains('Seating party of 1 for Bocchi.').should('be.visible');

    cy.contains('A1').parent().contains('Book').should('have.class', 'not-suggested')
      .click();

    // when seating a seat alone party at a table with an existing party, show a warning message
    cy.contains('The party you are seating requested to be seated alone, but this table has parties already seated. Are you sure you want to seat this party with others anyway?').should('be.visible');

    cy.contains('Back').click();

    // seat the seat alone party
    cy.contains('Seating party of 1 for Bocchi.').should('be.visible');

    cy.contains('A2').parent().contains('Book').should('not.have.class', 'not-suggested')
      .click();

    cy.contains('The party you are seating requested to be seated alone, but this table has parties already seated. Are you sure you want to seat this party with others anyway?').should('not.be.visible');

    cy.contains('Kotori').click();

    // mocking the barcode input
    cy.window().then((win) => {
      // eslint-disable-next-line no-param-reassign, prefer-destructuring
      win.document.getElementById('reservation_barcode_id').value = tableA2.barcodes[0];
    });

    cy.contains('Submit').click();

    // when seating a non-book alone party at a table with an existing seat alone party, show a
    // warning
    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Nako').parent().contains('Select').click();

    cy.contains('Seating party of 1 for Nako.').should('be.visible');

    cy.contains('A2').parent().contains('Book').click();

    cy.contains('This table already has a party seated who requested to be seated alone. Are you sure you want to seat this party with others anyway?').should('be.visible');
  });
});
