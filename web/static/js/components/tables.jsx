import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import Modal from 'react-bootstrap/Modal';
import Button from 'react-bootstrap/Button';
import Alert from 'react-bootstrap/Alert';
import { Socket } from 'phoenix';
import Waitlist from './waitlist';

class tableComponent extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.handleShow = this.handleShow.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.selectReservation = this.selectReservation.bind(this);

    this.state = {
      show: false,
      reservation: props.selectedReservation || {},
      tables: props.tables,
      waitlist: props.waitlist,
    };
  }

  componentDidMount() {
    const socket = new Socket('/socket', { params: { token: window.userToken } });
    socket.connect();
    const channel = socket.channel('room:lobby', {});
    channel.on('table_cleared', (payload) => {
      const { tables } = this.state;
      const updatedTables = tables.map(table => Object.assign(table, { barcodes: table.barcodes.map(barcode => (`${barcode.id}` === `${payload.id}` ? { id: barcode.id, size: 0, reservation: null } : barcode)) }));
      this.setState({ tables: updatedTables });
    });

    channel.on('waitlist_updated', (payload) => {
      this.setState({ waitlist: payload.waitlist });
    });

    channel.join()
      .receive('ok', (resp) => { console.log('Joined successfully', resp); })
      .receive('error', (resp) => { console.log('Unable to join', resp); });

    const interval = setInterval(() => this.setState({}), 60 * 1000);
    this.setState({ interval });
  }

  componentWillUnmount() {
    const { interval } = this.state;
    clearInterval(interval);
  }

  handleClose() {
    this.setState({ show: false });
  }

  handleShow() {
    this.setState({ show: true });
  }

  selectReservation(reservation) {
    this.setState({ reservation });
    window.history.pushState('tables', 'Title', `/tables${reservation.id ? `?reservation=${reservation.id}` : ''}`);
    this.handleClose();
  }

  render() {
    const {
      tables, show, reservation, waitlist,
    } = this.state;

    const hasOpenBarcodes = table => table.barcodes.reduce(
      (acc, barcode) => (barcode.reservation ? false || acc : true || acc), false,
    );

    const tableReservationCount = table => table.barcodes.reduce(
      (acc, barcode) => (barcode.reservation ? acc + 1 : acc), 0,
    );

    const takenSeats = table => table.barcodes.reduce(
      (acc, barcode) => (barcode.reservation ? acc + barcode.reservation.size : acc), 0,
    );

    const openSeats = table => table.max_capacity - takenSeats(table);

    const isAvailable = table => table.barcodes.length > 0
      && (reservation.id
        ? openSeats(table) >= reservation.size
        : openSeats(table) > 0)
      && hasOpenBarcodes(table);


    const maidsForTable = (barcode, index) => (
      barcode.reservation
        ? <p key={`table-maid-${index}`}>{barcode.reservation.maid.name}</p>
        : <p key={`table-maid-${index}`} hidden />
    );

    const patronsForTable = (barcode, index) => (
      barcode.reservation
        ? <p key={`table-patrons-${index}`}>{barcode.reservation.size}</p>
        : <p key={`table-patrons-${index}`} hidden />
    );

    const timeForTable = (barcode, index) => (
      barcode.reservation
        ? (
          <p
            key={`table-time-${index}`}
            className={
            `${moment.duration(moment().diff(barcode.reservation.time_in)) > 35 * 60 * 1000 ? 'overtime' : ''}
            ${moment.duration(moment().diff(barcode.reservation.time_in)) > 45 * 60 * 1000 ? 'way-overtime' : ''}`
            }
          >
            {moment.duration(moment().diff(barcode.reservation.time_in)).humanize()}
          </p>
        )
        : <p key={`table-time-${index}`} hidden />
    );

    const tableRow = (table) => {
      const bookLink = reservation.id ? `/reservations/${reservation.id}/seat/${table.id}` : `/reservations/new/${table.id}`;
      const suggestionClasses = reservation.seat_alone ? tableReservationCount(table) > 0 && 'not-suggested' : '';

      return (
        <tr key={`table-${table.id}`}>
          <td>{table.table_number}</td>
          <td>{table.max_capacity}</td>
          <td>{openSeats(table)}</td>
          <td>{table.barcodes.map(maidsForTable)}</td>
          <td>{table.barcodes.map(patronsForTable)}</td>
          <td>{table.barcodes.map(timeForTable)}</td>
          <td className="text-right">
            <span>
              {isAvailable(table)
            && <a href={bookLink} className={`btn btn-default btn-sm ${suggestionClasses}`}>Book</a>}
            </span>
          </td>
        </tr>
      );
    };

    return (
      <div>
        { reservation.id && (
        <Alert variant="warning">
          {`Seating party of ${reservation.size} for ${reservation.name}.`}
          <Button variant="link" onClick={() => this.selectReservation({})}>
          Cancel
          </Button>
        </Alert>
        )}
        <div className="btn-toolbar pull-right">
          <div className="btn-group">
            <Button variant="primary" onClick={this.handleShow}>
              Waitlist
            </Button>
          </div>
        </div>
        <h2>Tables</h2>
        <table className="table">
          <thead>
            <tr>
              <th>Table number</th>
              <th>Max capacity</th>
              <th>Open Seats</th>
              <th>Maids</th>
              <th># of Goshujinsama</th>
              <th>time</th>
              <th />
            </tr>
          </thead>
          <tbody>
            {tables.map(tableRow)}
          </tbody>
        </table>
        <Modal
          show={show}
          onHide={this.handleClose}
          size="lg"
          aria-labelledby="contained-modal-title-vcenter"
          centered
        >
          <Modal.Header closeButton>
            <Modal.Title id="contained-modal-title-vcenter">Waitlist</Modal.Title>
          </Modal.Header>

          <Modal.Body>
            <Waitlist
              waitlist={waitlist}
              modal
              selectReservation={this.selectReservation}
            />
          </Modal.Body>
        </Modal>
      </div>
    );
  }
}

tableComponent.propTypes = {
  tables: PropTypes.arrayOf(PropTypes.object).isRequired,
  waitlist: PropTypes.shape({
    entries: PropTypes.arrayOf(PropTypes.object),
  }).isRequired,
  // eslint-disable-next-line react/forbid-prop-types
  selectedReservation: PropTypes.object,
};

tableComponent.defaultProps = {
  selectedReservation: {},
};

export default tableComponent;
