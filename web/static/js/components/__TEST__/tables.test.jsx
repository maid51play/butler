import React from 'react';
import { render, fireEvent, screen } from '@testing-library/react';
import { within } from '@testing-library/dom';
import '@testing-library/jest-dom';
import TableComponent from '../tables';

const tables = [
  {
    id: 1,
    table_number: 'A1',
    max_capacity: 4,
    barcodes: [
      {
        id: 1,
        reservation: {
          id: 1,
          maid: {
            id: 1,
            name: 'hanayo',
          },
          size: 2,
          time_in: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
        },
      },
      { id: 2 },
      { id: 3 },
      { id: 4 },
    ],
  },
];

const nicoReservation = {
  id: 1,
  name: 'nico',
  size: 2,
  seat_alone: false,
  shinkansen: false,
  staff: false,
  time_waitlisted: '',
  notes: '',
};
const kotoriReservation = {
  id: 2,
  name: 'kotori',
  size: 4,
  seat_alone: false,
  shinkansen: false,
  staff: false,
  time_waitlisted: '',
  notes: '',
};
const rinReservation = {
  id: 3,
  name: 'rin',
  size: 1,
  seat_alone: true,
  shinkansen: false,
  staff: false,
  time_waitlisted: '',
  notes: '',
};

const waitlist = {
  total_pages: 1,
  page_number: 1,
  entries: [nicoReservation, kotoriReservation, rinReservation],
};

let dateNowSpy;
// eslint-disable-next-line no-undef
beforeAll(() => {
  // Lock Time

  // eslint-disable-next-line no-undef
  dateNowSpy = jest.spyOn(Date, 'now').mockImplementation(() => 1636507241759);
});
// eslint-disable-next-line no-undef
afterAll(() => {
  // Unlock Time
  dateNowSpy.mockRestore();
});

describe('#tables', () => {
  it('renders the table data', () => {
    render(<TableComponent tables={tables} waitlist={waitlist} />);

    const table = screen.getByRole('table');
    const [headers, ...rows] = within(table).getAllByRole('rowgroup');
    const [...columnNames] = within(headers).getAllByRole('columnheader');
    const [...values] = within(rows[0]).getAllByRole('cell');
    expect(columnNames[0].textContent).toEqual('Table number');
    expect(columnNames[1].textContent).toEqual('Max capacity');
    expect(columnNames[2].textContent).toEqual('Open Seats');
    expect(columnNames[3].textContent).toEqual('Maids');
    expect(columnNames[4].textContent).toEqual('# of Goshujinsama');
    expect(columnNames[5].textContent).toEqual('time');

    expect(values[0].textContent).toEqual('A1');
    expect(values[1].textContent).toEqual('4');
    expect(values[2].textContent).toEqual('2');
    expect(values[3].textContent).toEqual('hanayo');
    expect(values[4].textContent).toEqual('2');
    expect(values[5].textContent).toEqual('26 minutes');
  });

  describe('seating a party from the waitlist', () => {
    it('opens the waitlist waitlist', () => {
      render(<TableComponent tables={tables} waitlist={waitlist} />);

      fireEvent.click(screen.getByText('Waitlist'));

      expect(screen.getByText('nico'));
    });

    it('selects a party from the waitlist', () => {
      render(
        <TableComponent
          tables={tables}
          waitlist={waitlist}
          selectedReservation={nicoReservation}
        />,
      );

      expect(screen.getByText('Seating party of 2 for nico.'));
    });

    it('hides the Book Table button if the party won"t fit', () => {
      render(
        <TableComponent
          tables={tables}
          waitlist={waitlist}
          selectedReservation={kotoriReservation}
        />,
      );

      const table = screen.getByRole('table');
      const [, ...rows] = within(table).getAllByRole('rowgroup');
      const [...values] = within(rows[0]).getAllByRole('cell');

      expect(values[6].textContent).toEqual('');
    });

    it('styles the Book Table button if the party requested to be seated alone', () => {
      render(
        <TableComponent
          tables={tables}
          waitlist={waitlist}
          selectedReservation={rinReservation}
        />,
      );

      const table = screen.getByRole('table');
      const button = within(table).getByRole('link');

      expect(button.textContent).toEqual('Book');
      expect(button.className).toMatch('not-suggested');
    });
  });
});
