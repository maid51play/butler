import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import Pagination from 'react-bootstrap/Pagination';
import { Socket } from 'phoenix';

class waitlistComponent extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      waitlist: props.waitlist,
    };
  }

  componentDidMount() {
    const socket = new Socket('/socket', { params: { token: window.userToken } });
    socket.connect();
    const channel = socket.channel('room:lobby', {});

    channel.on('waitlist_seated', (payload) => {
      const { waitlist } = this.state;
      const entries = waitlist.entries.filter(({ id }) => id !== payload.id);
      const updatedWaitlist = Object.assign({}, waitlist, { entries });
      this.setState({ waitlist: updatedWaitlist });
    });

    channel.on('waitlist_updated', () => {
      // eslint-disable-next-line react/destructuring-assignment
      channel.push('new_waitlist_entries', { body: this.state.waitlist.page_number });
    });

    channel.on('new_waitlist_entries', (payload) => {
      this.setState({ waitlist: payload.body });
    });

    channel.join()
      .receive('ok', (resp) => { console.log('Joined successfully', resp); })
      .receive('error', (resp) => { console.log('Unable to join', resp); });
  }

  render() {
    const { waitlist } = this.state;
    const { modal, selectReservation, token } = this.props;

    const pages = [...Array(waitlist.total_pages + 1).keys()]
      .slice(
        Math.max(1, waitlist.page_number - 2),
        waitlist.page_number + 3,
      );

    const paginationItem = number => (
      <Pagination.Item key={number} active={number === waitlist.page_number} href={`/waitlist?page=${number}`}>
        {number}
      </Pagination.Item>
    );

    const waitlistRow = entry => (
      <tr key={`waitlist-${entry.id}`}>
        <td>{entry.name}</td>
        <td>{entry.size}</td>
        <td>{entry.seat_alone && '💖'}</td>
        <td>{moment(entry.time_waitlisted).format('h:mm a')}</td>
        <td>{entry.notes}</td>
        <td className="text-right">
          <span><a className="btn btn-default btn-xs" href={`/waitlist/${entry.id}/edit`}>Edit</a></span>
          {!modal && <span><a className="btn btn-danger btn-xs" data-confirm="Are you sure?" data-csrf={token} data-method="delete" data-to={`/waitlist/${entry.id}`} href={`/waitlist/${entry.id}`} rel="nofollow">Delete</a></span>}
          {modal && (<span><button type="button" className="btn btn-primary btn-xs" onClick={() => selectReservation(entry)}>Select</button></span>)}
        </td>
      </tr>
    );

    return (
      <div>
        {!modal && <h2>Waitlist</h2>}
        {!modal && <a href="/waitlist/new">New reservation</a>}
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Size</th>
              <th>Seat alone?</th>
              <th>Time waitlisted</th>
              <th>Notes</th>
              {modal && <th />}
              <th />
            </tr>
          </thead>
          <tbody>
            {waitlist.entries.map(waitlistRow)}
          </tbody>
        </table>
        {!modal && <a href="/waitlist/new">New reservation</a>}
        {!modal && (
        <Pagination>
          <Pagination.Item href="/waitlist?page=1">start</Pagination.Item>
          {waitlist.page_number !== 1 && <Pagination.Prev href={`/waitlist?page=${waitlist.page_number - 1}`} />}
          {pages.map(paginationItem)}
          {waitlist.page_number !== waitlist.total_pages && <Pagination.Next href={`/waitlist?page=${waitlist.page_number + 1}`} />}
          <Pagination.Item href={`/waitlist?page=${waitlist.total_pages}`}>end</Pagination.Item>
        </Pagination>
        )}
      </div>
    );
  }
}

waitlistComponent.propTypes = {
  waitlist: PropTypes.shape({
    entries: PropTypes.arrayOf(PropTypes.object),
  }).isRequired,
  modal: PropTypes.bool,
  selectReservation: PropTypes.func,
  token: PropTypes.string,
};

waitlistComponent.defaultProps = {
  modal: false,
  selectReservation: () => {},
  token: '',
};

export default waitlistComponent;
