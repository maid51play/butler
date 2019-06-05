import React from 'react';
import PropTypes from 'prop-types';
import WaitlistForm from './waitlistForm';

const waitlistEditComponent = ({ token, reservation }) => (
  <div>
    <h2>Edit Waitlist Reservation</h2>
    <WaitlistForm token={token} reservation={reservation} action={`/waitlist/${reservation.id}`} method="post" />
  </div>
);

waitlistEditComponent.propTypes = {
  token: PropTypes.string.isRequired,
  reservation: PropTypes.shape({
    name: PropTypes.string,
    size: PropTypes.number,
    seat_alone: PropTypes.bool,
    notes: PropTypes.string,
  }),
};

waitlistEditComponent.defaultProps = {
  reservation: {},
};

export default waitlistEditComponent;
