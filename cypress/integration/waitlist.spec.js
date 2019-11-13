// <reference types="Cypress" />

context('Waitlist seating', () => {
  const tableIndex = {};
  beforeEach(() => {
    cy.factorydb('table', { table_number: 'A1', max_capacity: '8' })
      .then((result) => { tableIndex.A1 = { id: result.body.id, parties: [] }; return result; })
      .then(() => {
        cy.factorydb('party', { table_id: tableIndex.A1.id })
          .then((result) => {
            tableIndex.A1 = {
              ...tableIndex.A1, parties: [...tableIndex.A1.parties, result.body.id],
            };
            console.log(tableIndex);
          });
      });

    cy.factorydb('maid', {
      name: 'Kotori',
      status: 'present',
      checked_in_at: new Date(),
    });

    cy.login();

    // get the table ids since I don't know how to get this from the factory directly QQ
    cy.visit('localhost:4001/parties');
    // cy.window().then((win) => {
    //   const rows = win.document.getElementsByTagName('tr');
    //   for (let i = 1; i < rows.length; i += 1) {
    //     const tableName = rows[i].children[1].innerHTML;
    //     const tableId = rows[i].children[2].children[0].children[0].href.split('/').pop();
    //     tableIndex[tableName] = tableId;
    //   }
    // });

    cy.visit('localhost:4001/');
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

    cy.contains('Book').click();

    cy.contains('Seating party of 6 for Hanayo.').should('be.visible');

    cy.contains('Kotori').click();

    let tableName;
    // mocking the barcode input
    cy.window().then((win) => {
      tableName = win.document.getElementById('reservation_table_number').value;
      // eslint-disable-next-line no-param-reassign, prefer-destructuring
      win.document.getElementById('reservation_party_id').value = tableIndex[tableName].parties[0];
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
      win.document.getElementById('reservation_party_id').value = tableIndex[tableName].parties[0];
    });

    cy.contains('Submit').click();

    cy.contains('Reservation cleared successfully.').should('be.visible');
  });

  it('waitlist with seat alone happy path', () => {
    cy.factorydb('reservation', { party_id: tableIndex[Object.keys(tableIndex)[0]].parties[0], table_number: 'A1' });

    cy.factorydb('party', { table_id: tableIndex.A1.id })
      .then((result) => {
        tableIndex.A1 = {
          ...tableIndex.A1, parties: [...tableIndex.A1.parties, result.body.id],
        };
      });

    cy.factorydb('table', { table_number: 'A2', max_capacity: '8' })
      .then((result) => { tableIndex.A2 = { id: result.body.id, parties: [] }; return result; })
      .then(() => {
        cy.factorydb('party', { table_id: tableIndex.A2.id })
          .then((result) => {
            tableIndex.A2 = {
              ...tableIndex.A2, parties: [...tableIndex.A2.parties, result.body.id],
            };
          });
        cy.factorydb('party', { table_id: tableIndex.A2.id })
          .then((result) => {
            tableIndex.A2 = {
              ...tableIndex.A2, parties: [...tableIndex.A2.parties, result.body.id],
            };
          });
      });

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

    cy.contains('New reservation').click();

    cy.contains('New Waitlist Reservation').should('be.visible');

    cy.get('#reservation_name')
      .type('Nako').should('have.value', 'Nako');

    cy.get('#reservation_size')
      .type('1').should('have.value', '1');

    cy.contains('Submit').click();

    cy.contains('Reservation created successfully.').should('be.visible');

    cy.contains('Nako').parent().contains('💖').should('not.be.visible');

    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Bocchi').parent().contains('Select').click();

    cy.contains('Seating party of 1 for Bocchi.').should('be.visible');

    cy.contains('A1').parent().contains('Book').should('have.class', 'not-suggested')
      .click();

    cy.contains('The party you are seating requested to be seated alone, but this table has parties already seated. Are you sure you want to seat this party with others anyway?').should('be.visible');

    cy.contains('Back').click();

    cy.contains('Seating party of 1 for Bocchi.').should('be.visible');

    cy.contains('A2').parent().contains('Book').should('not.have.class', 'not-suggested')
      .click();

    cy.contains('The party you are seating requested to be seated alone, but this table has parties already seated. Are you sure you want to seat this party with others anyway?').should('not.be.visible');

    cy.contains('Kotori').click();

    // mocking the barcode input
    cy.window().then((win) => {
      // eslint-disable-next-line no-param-reassign, prefer-destructuring
      win.document.getElementById('reservation_party_id').value = tableIndex.A2.parties[0];
    });

    cy.contains('Submit').click();

    cy.contains('Tables').click();

    cy.contains('button', 'Waitlist').click();

    cy.contains('td', 'Nako').parent().contains('Select').click();

    cy.contains('Seating party of 1 for Nako.').should('be.visible');

    cy.contains('A2').parent().contains('Book').click();
  });
});
