import React, { useState } from 'react';
import { format } from 'date-fns';
import PropTypes from 'prop-types';

const reserveTimeslot = ({ timeslots }) => {
  const [step, setStep] = useState('PICK_TIMESLOT');
  const [timeslot, setTimeslot] = useState();

  const onSelect = (event) => {
    // TODO: make a request for the first available timeslot at the selected time
    const applesauce = { id: -1, start_time: event.target.value, end_time: event.target.value };
    setStep('RESERVATION_FORM');
    setTimeslot(applesauce);
  };

  switch (step) {
    case 'PICK_TIMESLOT':
      return <PickTimeslot timeslots={timeslots} onSelect={onSelect} />;
    case 'RESERVATION_FORM':
      return <ReservationForm timeslot={timeslot} />;
    default:
      return <div>hi</div>;
  }
};

const PickTimeslot = ({ timeslots, onSelect }) => (
  <div style={{ textAlign: 'center' }}>
    <img src="images/fanimaid.png" alt="Fanimaid Cafe" style={{ height: '50px' }} />
    <div>
      <h2 className="title is-1">Today</h2>
      <h3 className="subtitle is-1">{ format(new Date(), 'eeee, MMMM d')}</h3>
    </div>
    <div>
      <h2 className="title is-2 is-primary">Available Reservations</h2>
      {timeslots.map(timeslot => <div key={timeslot.start_time}><button value={timeslot.start_time} className="button is-large is-fullwidth is-outlined" type="button" onClick={onSelect}>{format(new Date(timeslot.start_time), 'hh:mm a')}</button></div>)}
    </div>
  </div>
);

const ReservationForm = ({ timeslot }) => (
  <div style={{ textAlign: 'center' }}>
    <img src="images/fanimaid.png" alt="Fanimaid Cafe" style={{ height: '50px' }} />
    <div>
      <h2 className="title is-1">{ format(new Date(timeslot.start_time), 'hh:mm a') }</h2>
      <h3 className="subtitle is-1">{ format(new Date(timeslot.start_time), 'eeee, MMMM d')}</h3>
    </div>
    <div>
      <form>
        <label id="name" htmlFor="name">
          Name
          <input id="name" name="name" />
        </label>
        <label id="size" htmlFor="size">
          Party Size (4 is max.)
          <input id="size" name="size" />
        </label>
        <label id="email" htmlFor="email">
          Email
          <input id="email" name="email" />
        </label>
        <label id="email" htmlFor="email">
          Phone
          <input id="email" name="email" />
        </label>
      </form>
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
