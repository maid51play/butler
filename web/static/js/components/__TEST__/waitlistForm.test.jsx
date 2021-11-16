import React from 'react';
import { render, screen, hasInputValue } from '@testing-library/react';
import { within } from '@testing-library/dom';
import '@testing-library/jest-dom';
import WaitlistFormComponent from '../waitlistForm';

const reservation = {
  id: 1,
  name: 'nico',
  size: 2,
  seat_alone: true,
  shinkansen: false,
  staff: false,
  time_waitlisted: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
  notes: 'nico notes',
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

describe('#waitlistForm', () => {
  it('renders a blank form when no reservation is passed in', () => {
    render(<WaitlistFormComponent token="token" action="/waitlist" method="post" />);

    expect(screen.getByLabelText('Name:')).toHaveValue('');
    expect(screen.getByLabelText('Size:')).toHaveValue(null);
    expect(screen.getByLabelText('Seat Alone:')).not.toBeChecked();
    expect(screen.getByLabelText('Notes:')).toHaveValue('');
  });

  it('renders existing waitlist data', () => {
    render(<WaitlistFormComponent token="token" action="/waitlist" method="post" reservation={reservation} />);

    expect(screen.getByLabelText('Name:')).toHaveValue('nico');
    expect(screen.getByLabelText('Size:')).toHaveValue(2);
    expect(screen.getByLabelText('Seat Alone:')).toBeChecked();
    expect(screen.getByLabelText('Notes:')).toHaveValue('nico notes');
  });
});
