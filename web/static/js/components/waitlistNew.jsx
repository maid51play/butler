import React from 'react';
import PropTypes from 'prop-types';
import WaitlistForm from './waitlistForm';

const waitlistNewComponent = ({ token }) => (
  <div>
    <h2>New Waitlist Reservation</h2>
    <WaitlistForm token={token} action="/waitlist" method="post" />
  </div>
);

waitlistNewComponent.propTypes = {
  token: PropTypes.string.isRequired,
};

export default waitlistNewComponent;
