import React from 'react';
import PropTypes from 'prop-types';

const waitlistFormComponent = ({
  token,
  action,
  method,
  reservation,
}) => (
  <div>
    <form acceptCharset="UTF-8" action={action} method={method}>
      {reservation.id && <input name="_method" type="hidden" value="put" />}
      <input name="_csrf_token" type="hidden" value={token} />
      <input name="_utf8" type="hidden" value="✓" />
      <div className="form-group">
        <label className="control-label" htmlFor="reservation_name">
          Name:
          <input className="form-control" id="reservation_name" name="reservation[name]" defaultValue={reservation && reservation.name} />
        </label>
      </div>

      <div className="form-group">
        <label className="control-label" htmlFor="reservation_size">
          Size:
          <input className="form-control" id="reservation_size" name="reservation[size]" type="number" defaultValue={reservation && reservation.size} />
        </label>
      </div>

      <div className="form-group">
        <label className="control-label" htmlFor="reservation_seat_alone">
          Seat Alone:
          <input className="checkbox" id="reservation_seat_alone" name="reservation[seat_alone]" type="checkbox" value="true" defaultChecked={reservation && reservation.seat_alone} />
        </label>
      </div>

      <div className="form-group">
        <label className="control-label" htmlFor="reservation-notes">
          Notes:
          <textarea className="form-control" id="reservation-notes" name="reservation[notes]" defaultValue={reservation && reservation.notes} />
        </label>
      </div>

      <div className="form-group">
        <button className="btn btn-primary" type="submit">Submit</button>
      </div>
    </form>
    <a href="/waitlist">Back</a>
    {reservation && <a className="btn btn-danger btn-xs pull-right" data-confirm="Are you sure?" data-csrf={token} data-method="delete" data-to={`/waitlist/${reservation.id}`} href={`/reservations/${reservation.id}`} rel="nofollow">Delete</a>}
  </div>
);

waitlistFormComponent.propTypes = {
  token: PropTypes.string.isRequired,
  action: PropTypes.string.isRequired,
  method: PropTypes.string.isRequired,
  reservation: PropTypes.shape({
    name: PropTypes.string,
    size: PropTypes.number,
    seat_alone: PropTypes.bool,
    notes: PropTypes.string,
  }),
};

waitlistFormComponent.defaultProps = {
  reservation: {},
};

export default waitlistFormComponent;
