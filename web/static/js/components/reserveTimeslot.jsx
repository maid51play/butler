import React from 'react';
import { format } from 'date-fns';
import PropTypes from 'prop-types';

const reserveTimeslot = ({ timeslots }) => (
  <div style={{ textAlign: 'center' }}>
    <img src="images/fanimaid.png" alt="Fanimaid Cafe" style={{ height: '50px' }} />
    <div>
      <h2 className="title is-1">Today</h2>
      <h3 className="subtitle is-1">{ format(new Date(), 'eeee, MMMM d')}</h3>
    </div>
    <div>
      <h2 className="title is-2 is-primary">Available Reservations</h2>
      {timeslots.map(timeslot => <div key={timeslot.start_time}><button className="button is-large is-fullwidth is-outlined" type="button">{format(new Date(timeslot.start_time), 'hh:mm a')}</button></div>)}
    </div>
  </div>
);

reserveTimeslot.propTypes = {
  timeslots: PropTypes.arrayOf(PropTypes.object),
};

reserveTimeslot.defaultProps = {
  timeslots: [],
};

export default reserveTimeslot;
